#!/usr/bin/env ruby

ARGV.each do |x|
  base = `basename #{x}`
  prefixes = %w(29.7x29.7_ 30x30_ 40x40_ 42x42_ 50x50_ 59.4x59.4_ 60x60_ 65x65_ 70x70_ 75x75_ 80x80_ 90x90_ 100x100_ 120x120_ 140x140_)
  prefixes.each do |prefixe|
    system("convert #{x} -duplicate 0 FRAME/#{prefixe + base}")
  end
end

def baguette_calc(z, d)

  temp_baguette = z / 100
  divider = temp_baguette + d.to_i

  baguette = z / divider
  baguette *= 10
  baguette = 1000 - baguette

  return baguette

end

files = Dir.glob("FRAME/*.jpg")
files.each do |f|
  f_cut              = f.split('/')

  name_base      = f_cut[1]
  name_dimension = name_base.split('_')[0].split('x')[0]

  if name_base.include?('alu')

    baguette = baguette_calc(200.0, name_dimension)

    system("exiftool -comment=#{baguette} #{f}")
    system("magick #{f} -gravity center \\( -clone 0 -crop 936x936+0+0 -resize \"#{baguette}x#{baguette}+0+0\" \\) -geometry +0+0 -composite #{f}")
    puts "#{f}\nBaguette => #{baguette}\n----------------------\n\n"

  else name_base.include?('wood')

    if name_base.include?('wood_black_large') || name_base.include?('wood_white_large')

      baguette = baguette_calc(800.0, name_dimension)

      system("exiftool -comment=#{baguette} #{f}")
      system("magick #{f} -gravity center \\( -clone 0 -crop 788x788+0+0 -resize \"#{baguette}x#{baguette}+0+0\" \\) -geometry +0+0 -composite #{f}")
      puts "#{f}\nBaguette => #{baguette}\n----------------------\n\n"

    elsif name_base.include?("vintage")
      baguette = baguette_calc(700.0, name_dimension)

      system("exiftool -comment=#{baguette} #{f}")
      puts "#{f}\nBaguette => #{baguette}...\n----------------------\n\n"

      baguette = baguette_calc(225.0, name_dimension)

      system("exiftool -comment=#{baguette} #{f}")
      puts "#{f}\nBaguette => #{baguette}...\n----------------------\n\n"

    else

      baguette = baguette_calc(400.0, name_dimension)

      system("exiftool -comment=#{baguette} #{f}")
      system("magick #{f} -gravity center \\( -clone 0 -crop 880x880+0+0 -resize \"#{baguette}x#{baguette}+0+0\" \\) -geometry +0+0 -composite #{f}")
      puts "#{f}\nBaguette => #{baguette}\n----------------------\n\n"

    end
  end
end

def homothetie_calc

  size_to_resizes = {
    '29.7x29.7' =>  ['21x29.7'],
    '30x30' =>      ['20x30', '30x30'],
    '40x40' =>      ['30x40', '40x40'],
    '42x42' =>      ['29.7x42'],
    '50x50' =>      ['35x50', '40x50', '50x50'],
    '59.4x59.4' =>  ['42x59.4'],
    '60x60' =>      ['40x60', '45x60', '50x60', '60x60'],
    '65x65' =>      ['50x65'],
    '70x70' =>      ['50x70', '70x70'],
    '75x75' =>      ['50x75'],
    '80x80' =>      ['60x80', '80x80'],
    '90x90' =>      ['60x90', '70x90'],
    '100x100' =>    ['50x100', '70x100'],
    '120x120' =>    ['80x120'], # On ne vend pas pour l'instant
    '140x140' =>    ['100x140'] # On ne vend pas pour l'instant
  }


  Dir.glob('FRAME/*.jpg').each do |f|

    size, material, color, style, thickness = f.split('/').last[0..-5].split('_')
    width, height = size.split('x').map(&:to_f)

    new_name = [material, color, style, thickness].reject(&:nil?).join('-')

    size_to_resizes[size].each do |new_size|
      new_width, new_height = new_size.split('x').map(&:to_f)
      new_name_temp = "FRAME/#{new_size + "-" + new_name}.jpg"
      ratio = new_width * 100 / width
      ratio = ratio.round

      puts "\n----------------------\n\nFile        => #{f}\nFolder(s)   => #{new_size + "/"}\nNew width   => #{new_width}\nNew ratio   => #{ratio}\n\nProcessing  => #{new_name_temp}\n"

      puts "Creating mask for #{size + "_" +new_name}"
      x = system("exiftool -s -S -comment #{f}")
      y = 1000 - f.to_i
      system("convert -size 1000x1000 xc:black -fill white -draw  'polygon #{y},#{y} #{y},#{x} #{x},#{x} #{x},#{y}' #{f[0..-5]}_MASK.jpg")

      # system(" magick #{f} -liquid-rescale #{ratio}x100% \
      #         -font GTEestiProText-Bold -pointsize 100 -kerning 2 \
      #         -gravity center -fill '#355548' -annotate +0-50 #{new_size} \
      #         -background none -size 470x -font GTEestiProText-Medium -pointsize 25 -kerning 3 -fill '#355548' \
      #         caption:'#{new_name.gsub(/_/, '\ ').upcase + " FRAME"}' \
      #         -gravity center -geometry +0+20 -compose over -composite \
      #         -font GTEestiProText-Medium -pointsize 20 -interline-spacing 8 -kerning 3 \
      #         -background none -fill '#355548' -font GTEestiProText-Medium -pointsize 20 -interline-spacing 8 -kerning 3 \
      #         -gravity center -annotate +0-300 'PREMIUM QUALITY FRAME\nWITH PROTECTIVE PLEXIGLAS' \
      #         LOGO.png -geometry +0+275 -composite \
      #         -compose Screen -gravity center \
      #         REFLECTION/#{rand(1..3)}.jpg #{f} \
      #         #{new_name_temp} && display #{new_name_temp} && rm #{new_name_temp}")

      system(" magick #{f} -liquid-rescale #{ratio}x100% \
              -font GTEestiProText-Bold -pointsize 100 -kerning 2 \
              -gravity center -fill '#355548' -annotate +0-50 #{new_size} \
              -background none -size 470x -font GTEestiProText-Medium -pointsize 25 -kerning 3 -fill '#355548' \
              caption:'#{new_name.gsub(/_/, '\ ').upcase + " FRAME"}' \
              -gravity center -geometry +0+20 -compose over -composite \
              -font GTEestiProText-Medium -pointsize 20 -interline-spacing 8 -kerning 3 \
              -background none -fill '#355548' -font GTEestiProText-Medium -pointsize 20 -interline-spacing 8 -kerning 3 \
              -gravity center -annotate +0-300 'PREMIUM QUALITY FRAME\nWITH PROTECTIVE PLEXIGLAS' \
              LOGO.png -geometry +0+275 -composite \
              #{new_name_temp}")

      resize_format = %w(1000x1000 700x700) # TODO: rajouter les 450x450 après les tests
      resize_format.each do |resize|
        new_path_name = "FRAME/#{new_size + "/" + resize + "/" + new_size + "-" + new_name}.jpg"
        system("yoga image -v --resize #{resize} --jpeg-quality 90 #{new_name_temp} #{new_path_name}")
      end

      puts "\nImage processed !"
    end
  end
end


homothetie_calc

  # image      = Magick::Image.from_blob(URI.parse(original_link(product)).open.read).first
  # blob_image = image.resize_to_fit!(450).strip!.blur_image(5, 3).to_blob do |img|
  #   img.quality   = 20
  #   img.format    = 'JPEG'
  #   img.interlace = Magick::PlaneInterlace

  # i18n = {
  #   'fr' => {
  #     premium: "Cadre qualité premium",
  #     plexiglas: "Avec plexiglas protecteur",
  #     frame: "Cadre",

  #     color: {
  #       black: "noir",
  #       white: "blanc",
  #       gold: "doré",
  #       copper: "cuivré",
  #       silver: "argenté"
  #     },

  #     material: {
  #       aluminium: "aluminium",
  #       wood: "bois"
  #     },

  #     optionnal: {
  #       vintage: "vintage",
  #       ancient: "antique"
  #     },

  #     thick: "large"
  #   },

  #   'en' => {
  #     premium: "premium quality frame",
  #     plexiglas: "with protective plexiglas",
  #     frame: "Frame",

  #     color: {
  #       black: "black",
  #       white: "white",
  #       gold: "gold",
  #       copper: "copper",
  #       silver: "silver"
  #     },

  #     material: {
  #       aluminium: "aluminium",
  #       wood: "wooden"
  #     },

  #     optionnal: {
  #       vintage: "vintage",
  #       ancient: "ancient"
  #     },

  #     thick: "wide"
  #   },
  #   'de' => {
  #     premium: "premium quality frame",
  #     plexiglas: "with protective plexiglas",
  #     frame: "Frame",

  #     color: {
  #       black: "black",
  #       white: "white",
  #       gold: "gold",
  #       copper: "copper",
  #       silver: "silver"
  #     },

  #     material: {
  #       aluminium: "aluminium",
  #       wood: "wooden"
  #     },

  #     optionnal: {
  #       vintage: "vintage",
  #       ancient: "ancient"
  #     },

  #     thick: "wide"
  #   },

  #   'es' => [],
  #   'it' => [],
  #   'de' => [],
  #   'nl' => [],
  #   'sv' => []
  # }
