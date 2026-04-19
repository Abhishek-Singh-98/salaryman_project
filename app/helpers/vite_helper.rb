module ViteHelper
  def vite_asset_path(entry)
    if Rails.env.development?
      "http://localhost:5173#{entry}"
    else
      manifest = JSON.parse(File.read(Rails.root.join("public/vite/.vite/manifest.json")))
      "/vite/#{manifest[entry]["file"]}"
    end
  end
end