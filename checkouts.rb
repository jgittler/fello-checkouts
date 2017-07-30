require "sinatra"
require "json"
require "pony"

get "/" do
  if params["secret"] == ENV["SECRET"]
    @checkouts = Dir.glob("*.json").map do |file|
      JSON.parse(File.read(file))
    end

    erb :index
  else
    status 401
  end
end

post "/create" do
  email = params["email"]
  data = _build_blob(params)

  File.open("./#{email}-#{Time.now}.json", "w+") do |f|
    f.write(data)
  end

  _send_email(data)

  status 201
end

def _send_email(data)
  Pony.mail({
    to: "jason@felloeyewear.com",
    cc: "jonathan@felloeyewear.com",
    from: "contact@felloeyewear.com",
    subject: "New Checkout Started",
    body: data.inspect
    via: :smtp,
    via_options: {
      :address              => "smtp.gmail.com",
      :port                 => "587",
      :enable_starttls_auto => true,
      :user_name            => "contact@felloeyewear",
      :password             => ENV["EMAIL_PASSWORD"],
      :authentication       => :plain,
      :domain               => "gmail.com"
    }
  })
end

def _build_blob(params)
  {
    email: params["email"],
    device: params["device"],
    item: params["item"],
    time: Time.now
  }.to_json
end
