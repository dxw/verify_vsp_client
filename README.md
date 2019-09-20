[![Build status](https://github.com/dxw/verify_vsp_client/workflows/Build/badge.svg)](https://github.com/dxw/verify_vsp_client/actions)
[![License](http://img.shields.io/:license-mit-blue.svg)](https://mit-license.org/)

# Verify VSP Client

Ruby client for sending and receiving requests to a [Verify Service Provider] allowing you to
connect to [GOV.UK Verify]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'verify_vsp_client'
```

And then execute:

    $ bundle

Create a new `verify_vsp_client.rb` initialiser in `config/initializers`:

```ruby
VerifyVspClient.configure do |config|
  config.vsp_host = YOUR_VSP_HOST
end
```

## Usage

For a more detailed explanation of how to send and receive requests to the VSP, read the [GOV.UK Verify docs](https://www.docs.verify.service.gov.uk/get-started/set-up-successful-verification-journey/)

### Generate an authentication request

An authentication request with contain a `samlRequest`, `requestId` and `ssoLocation`.
You will need to store the `requestId` and access it later as part of translating the response:

```ruby
def new
  @verify_authentication_request = VerifyVspClient::AuthenticationRequest.generate
  session[:verify_request_id] = @verify_authentication_request.request_id
end
```

### Send the authentication request to the VSP

Create a form that makes a POST to `ssoLocation` containing a `SAMLRequest` hidden field.
The form should look something like this:
 
```erbruby
<%= form_tag @verify_authentication_request.sso_location, authenticity_token: false do %>
  <h1>Continue to next step</h1>
  <%= hidden_field_tag "relayState" %>
  <%= hidden_field_tag "SAMLRequest", @verify_authentication_request.saml_request %>
  <p>If your browser does not redirect in a few seconds, please press the "Continue" button.</p>
  <%= submit_tag "Continue" %>
<% end %>

<!-- JavaScript to automatically submit the form and POST to `ssoLocation` -->
<script>
  var form = document.forms[0];
  form.setAttribute('style', 'display: none;');
  window.setTimeout(function () { form.removeAttribute('style') }, 5000);
  form.submit()
</script>
```

### Request to translate the SAML response

Your application will receive a POST containing a SAMLResponse. Because the POST is being sent 
from an external source we'll need to skip verifying CSRF token for this action:

```ruby
skip_before_action :verify_authenticity_token, only: [:create]
  
def create
  @response = VerifyVspClient::Response.translate(
    saml_response: params["SAMLResponse"],
    request_id: session[:verify_request_id],
    level_of_assurance: "LEVEL_2"
  )
  if @response.verified?
    # The user has successfully verified their identity, you can access
    # the information about the user's identity using: 
    @response.parameters
  else
    # It's important for your app to also handle the failure scenarios:
    # @response.scenario == VerifyVspClient::AUTHENTICATION_FAILED_SCENARIO
    # @response.scenario == VerifyVspClient::NO_AUTHENTICATION_SCENARIO
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run 
the tests. You can also run `bin/console` for an interactive prompt that will allow you to 
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new 
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which 
will create a git tag for the version, push git commits and tags, and push the `.gem` file 
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dxw/verify_vsp_client. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VerifyVspClient project’s codebases, issue trackers, chat rooms and 
mailing lists is expected to follow the [code of conduct](https://github.com/dxw/verify_vsp_client/blob/master/CODE_OF_CONDUCT.md).

[Verify Service Provider]: https://github.com/alphagov/verify-service-provider
[GOV.UK Verify]: https://www.verify.service.gov.uk/
