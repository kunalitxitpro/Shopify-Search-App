class LoaderUploader < CarrierWave::Uploader::Base
  if true
    storage :fog
  else
    storage :file
  end

  def store_dir
    "articles"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
