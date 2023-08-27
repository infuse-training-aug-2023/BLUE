import requests
import zipfile
import re
import io
import os
import subprocess
import json
from bs4 import BeautifulSoup


class WebHelper():
    def download_and_extract(self, url, path):
        result = requests.get(url, allow_redirects=True)
        result_zip = zipfile.ZipFile(io.BytesIO(result.content))
        result_zip.extractall(path)


class PowerShellHelper():
    def __init__(self) -> None:
        self.system_root = os.environ['SYSTEMROOT']
        self.powershell_locations = [
            self.system_root + r'\System32\WindowsPowerShell\v1.0\powershell.exe',
            self.system_root + r'\SysWOW64\WindowsPowerShell\v1.0\powershell.exe',
        ]
        self.powershell_path = self.get_powershell_location()

    def get_powershell_location(self):
        for path in self.powershell_locations:
            if os.path.exists(path):
                return path
        return "powershell"

    def get_file_version_command(self, path):
        return r'(Get-Item -Path ' + path + ').VersionInfo.FileVersion'

    def get_registry_version_command(self, path):
        return r'(Get-ItemProperty -Path Registry::' + path + ').version'

    def get_powershell_command_output(self, command):
        result = subprocess.run([self.powershell_path, "-Command", command], capture_output=True)
        output = result.stdout.decode('UTF-8')
        return output.replace("\r\n", "")


class Driver():
    def __init__(self, browser_details, driver_path):
        self.browser_details = browser_details
        self.driver_path = driver_path

    def get_local_driver_major_version(self):
        if(os.path.exists(self.driver_path)):
            output = subprocess.check_output(self.driver_path + ' --version').decode()
            if "geckodriver" in output:
                local_driver_major_version = output.split(" ")[1]
            else:
                local_driver_major_version = output.split(" ")[1].split(".")[0]
        else:
            local_driver_major_version = 0
        return local_driver_major_version

    def check_if_driver_update_needed(self):
        self.local_browser_version = self.get_browser_version()
        local_driver_major_version = self.get_local_driver_major_version()
        driver_needs_update = local_driver_major_version != self.local_browser_version.split(".")[0]
        return driver_needs_update

    def get_browser_version(self):
        try:
            local_browser_version = Browser().get_local_browser_version(self.browser_details)
        except Exception:
            local_browser_version = self.get_latest_stable_driver_version(self.browser_details.latest_driver_release_url)
        return local_browser_version

    def get_latest_stable_driver_version(self, url):
        return requests.get(url).text.replace("\r\n", "")


class Browser():
    def get_local_browser_version(self, browser_details):
        powershell_helper = PowerShellHelper()
        for path in browser_details.installation_locations:
            cmd = powershell_helper.get_file_version_command(path)
            version = powershell_helper.get_powershell_command_output(cmd)
            if version != "":
                return version
        for path in browser_details.registry_locations:
            cmd = powershell_helper.get_registry_version_command(path)
            version = powershell_helper.get_powershell_command_output(cmd)
            if version != "":
                return version
        raise Exception("Browser not installed.")


class BrowserDetails():
    def __init__(self, latest_driver_release_url, installation_locations, registry_locations):
        self.latest_driver_release_url = latest_driver_release_url
        self.installation_locations = installation_locations
        self.registry_locations = registry_locations


class ChromeDriver(Driver):
    def __init__(self, driver_dir, chrome_driver_path):
        self.driver_dir = driver_dir
        super().__init__(
            BrowserDetails(
                "https://chromedriver.storage.googleapis.com/LATEST_RELEASE",
                [
                    r'"$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"',
                    r'"$env:PROGRAMFILES (x86)\Google\Chrome\Application\chrome.exe"',
                    r'"$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"'
                ],
                [
                    r'"HKCU\SOFTWARE\Google\Chrome\BLBeacon"',
                    r'"HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome"'
                ]
            ),
            chrome_driver_path
        )

    def update_driver_if_needed(self):
        if self.check_if_driver_update_needed():
            self.download_chrome_driver(self.local_browser_version)

    def get_latest_chrome_driver_version(self, chrome_major_version):
        source = requests.get("https://chromedriver.chromium.org/downloads").text
        soup = BeautifulSoup(source, 'lxml')
        download_tag = soup.find("a", href=re.compile("path=" + chrome_major_version))
        return download_tag.get('href').split("=")[1].replace("/", "")

    def download_chrome_driver(self, chrome_browser_version):
        chrome_driver_version = self.get_latest_chrome_driver_version(chrome_browser_version.split(".")[0])
        download_url = "https://chromedriver.storage.googleapis.com/" + chrome_driver_version + "/chromedriver_win32.zip"
        WebHelper().download_and_extract(download_url, self.driver_dir)


class EdgeDriver(Driver):
    def __init__(self, driver_dir, edge_driver_path):
        self.driver_dir = driver_dir
        super().__init__(
            BrowserDetails(
                "https://msedgewebdriverstorage.blob.core.windows.net/edgewebdriver/LATEST_STABLE",
                [
                    r'"$env:PROGRAMFILES\Microsoft\Edge\Application\msedge.exe"',
                    r'"$env:PROGRAMFILES (x86)\Microsoft\Edge\Application\msedge.exe"'
                ],
                [
                    r'"HKCU\SOFTWARE\Microsoft\Edge\BLBeacon"',
                ]
            ),
            edge_driver_path
        )

    def update_driver_if_needed(self):
        if self.check_if_driver_update_needed():
            self.download_edge_driver(self.local_browser_version)

    def download_edge_driver(self, edge_browser_version):
        download_url = "https://msedgedriver.azureedge.net/" + edge_browser_version + "/edgedriver_win64.zip"
        WebHelper().download_and_extract(download_url, self.driver_dir)


class FireFoxDriver(Driver):
    LATEST_FIREFOX_DRIVER_RELEASE_DETAILS_URL = "https://api.github.com/repos/mozilla/geckodriver/releases/latest"

    def __init__(self, driver_dir, firefox_driver_path):
        self.driver_dir = driver_dir
        super().__init__(None, firefox_driver_path)

    def get_latest_firefox_driver_version_number(self, url):
        return json.loads(requests.get(url).text)['name']

    def download_firefox_driver(self):
        driver_version_number = self.get_latest_firefox_driver_version_number(self.LATEST_FIREFOX_DRIVER_RELEASE_DETAILS_URL)
        download_url = f"https://github.com/mozilla/geckodriver/releases/download/v{driver_version_number}/geckodriver-v{driver_version_number}-win64.zip"
        WebHelper().download_and_extract(download_url, self.driver_dir)

    def check_if_driver_update_needed(self):
        local_driver_version = self.get_local_driver_major_version()
        latest_version_number = self.get_latest_firefox_driver_version_number(self.LATEST_FIREFOX_DRIVER_RELEASE_DETAILS_URL)
        return local_driver_version != latest_version_number

    def update_driver_if_needed(self):
        if self.check_if_driver_update_needed():
            self.download_firefox_driver()


LOCAL_DRIVER_DIR = os.environ['APPDATA'] + r"\useMango\Drivers"
LOCAL_CHROME_DRIVER = LOCAL_DRIVER_DIR + r"\chromedriver.exe"
LOCAL_EDGE_DRIVER = LOCAL_DRIVER_DIR + r"\msedgedriver.exe"
LOCAL_FIREFOX_DRIVER = LOCAL_DRIVER_DIR + r"\geckodriver.exe"


def main():
    ChromeDriver(LOCAL_DRIVER_DIR, LOCAL_CHROME_DRIVER).update_driver_if_needed()
    EdgeDriver(LOCAL_DRIVER_DIR, LOCAL_EDGE_DRIVER).update_driver_if_needed()
    FireFoxDriver(LOCAL_DRIVER_DIR, LOCAL_FIREFOX_DRIVER).update_driver_if_needed()


if __name__ == "__main__":
    main()
