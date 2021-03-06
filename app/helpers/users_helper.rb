module UsersHelper
  def gravatar_for user, options = {size: Settings.constant.default_avatar_size}
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = Settings.gravatar % {id: gravatar_id, size: size}
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
