defmodule ViexTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  test "lookup" do
    stub_response("lookup")
    response = Viex.lookup("NL854265259B01")

    assert response == %Viex.Response{
             address: "VIJZELSTRAAT 00068\n1017HL AMSTERDAM",
             company: "GITHUB B.V.",
             valid: true
           }

    stub_response("lookup_with_requester_vat")
    response = Viex.lookup("NL854265259B01", requester_vat: "IE6388047V")

    assert response == %Viex.ApproxResponse{
             request_identifier: "WAPIAAAAYnkVx97D",
             trader_address: "VIJZELSTRAAT 00068\n1017HL AMSTERDAM",
             trader_city: nil,
             trader_company_type: "---",
             trader_name: "GITHUB B.V.",
             trader_postcode: nil,
             trader_street: nil,
             valid: true
           }
  end

  test "lookup with invalid VAT number" do
    stub_response("lookup_invalid")
    response = Viex.lookup("NL9999999")

    assert response == %Viex.Response{
             address: "---",
             company: "---",
             valid: false
           }

    stub_response("lookup_invalid_with_requester_vat")
    response = Viex.lookup("NL9999999", requester_vat: "IE6388047V")

    assert response == %Viex.ApproxResponse{
             trader_city: nil,
             trader_company_type: "---",
             trader_postcode: nil,
             trader_street: nil,
             request_identifier: nil,
             trader_address: "---",
             trader_name: "---",
             valid: false
           }
  end

  test "lookup with requests limit reached" do
    stub_response("lookup_requests_limit_reached")
    response = Viex.lookup("NL9999999")

    assert response == {:error, :too_many_requests}
  end

  test "valid?" do
    stub_response("valid")
    assert Viex.valid?("NL854265259B01") == true

    stub_response("valid_with_requester_vat")
    assert Viex.valid?("NL854265259B01", requester_vat: "IE6388047V") == true
  end

  test "valid? with invalid VAT number" do
    stub_response("valid_invalid")
    assert Viex.valid?("NL9999999") == false

    stub_response("valid_invalid_with_requester_vat")
    assert Viex.valid?("NL9999999", requester_vat: "IE6388047V") == false
  end

  # Sets a one-shot Mox expectation returning the recorded response for `cassette`.
  defp stub_response(cassette) do
    expect(Viex.HTTPClientMock, :post, fn _url, _body, _headers, _options ->
      Viex.Cassette.response(cassette)
    end)
  end
end
