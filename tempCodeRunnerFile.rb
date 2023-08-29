
  def test_find_elements_returns_mock_elements
    results = @wrapper.find_elements(:css, '#navbarNavAltMarkup > div:nth-child(1)')
    assert_equal('Home', results[0].text)
    assert_equal('About Us', results[2].text)
  end