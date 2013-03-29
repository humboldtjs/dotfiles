module Cask::Actions
  def linkapps
    Pathname.glob("#{destination_path}/**/*.app").each do |app|
      destination = Cask.appdir.join(app.basename)
      target = destination_path.join(app)
      FileUtils.cp_r(target, destination)
    end
  end
end
