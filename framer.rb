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
  divider       = temp_baguette + d.to_i
  min           = z / divider
  min           *= 10
  baguette      = []
  baguette[1]   = min
  baguette[0]   = 1000 - min

  return baguette

end

files = Dir.glob("FRAME/*.jpg")

files.each do |f|
  f_cut              = f.split('/')
  name_base      = f_cut[1]
  name_dimension = name_base.split('_')[0].split('x')[0]

  if name_base.include?('alu')

    baguette = baguette_calc(200.0, name_dimension)
    system("exiftool -overwrite_original -comment=#{baguette} #{f}")

    system("magick #{f} \
            \( -size 1000x1000 xc:none -fill white -draw \'fill-opacity 0.4 rectangle #{baguette[1]},#{baguette[1]} #{baguette[0]},#{baguette[0]}\' \) \
            -compose Screen -composite #{f}")

    system("magick #{f} -gravity center \\( -clone 0 -crop 936x936+0+0 -resize \"#{baguette[0]}x#{baguette[0]}+0+0\" \\) -geometry +0+0 -composite #{f}")
    puts "#{f}\nBaguette => #{baguette}\n----------------------\n\n"

  else name_base.include?('wood')

    if name_base.include?('wood_black_large') || name_base.include?('wood_white_large')
      baguette = baguette_calc(800.0, name_dimension)
      system("exiftool -overwrite_original -comment=#{baguette[0]} #{f}")
      system("magick #{f} \
              \( -size 1000x1000 xc:none -fill white -draw \'fill-opacity 0.4 rectangle #{baguette[1]},#{baguette[1]} #{baguette[0]},#{baguette[0]}\' \) \
              -compose Screen -composite #{f}")
        system("magick #{f} -gravity center \\( -clone 0 -crop 788x788+0+0 -resize \"#{baguette[0]}x#{baguette[0]}+0+0\" \\) -geometry +0+0 -composite #{f}")
      puts "#{f}\nBaguette => #{baguette[0]}\n----------------------\n\n"

    elsif name_base.include?("vintage")

      baguette = baguette_calc(860.0, name_dimension)
      system("exiftool -overwrite_original -comment=#{baguette[0]} #{f}")
      # system("magick #{f} \
      #         \( -size 1000x1000 xc:none -fill white -draw \'fill-opacity 0.4 rectangle #{baguette[1]},#{baguette[1]} #{baguette[0]},#{baguette[0]}\' \) \
      #         -compose Screen -composite #{f}")
      puts "#{f}\nBaguette => #{baguette[0]}...\n----------------------\n\n"

    elsif name_base.include?("ancient")

      baguette = baguette_calc(475.0, name_dimension)
      system("exiftool -overwrite_original -comment=#{baguette[0]} #{f}")
      system("magick #{f} \
        \( -size 1000x1000 xc:none -fill white -draw \'fill-opacity 0.4 rectangle #{baguette[1]},#{baguette[1]} #{baguette[0]},#{baguette[0]}\' \) \
        -compose Screen -composite #{f}")
      puts "#{f}\nBaguette => #{baguette[0]}...\n----------------------\n\n"

    else

      baguette = baguette_calc(400.0, name_dimension)
      system("exiftool -overwrite_original -comment=#{baguette[0]} #{f}")
      system("magick #{f} \
              \( -size 1000x1000 xc:none -fill white -draw \'fill-opacity 0.4 rectangle #{baguette[1]},#{baguette[1]} #{baguette[0]},#{baguette[0]}\' \) \
              -compose Screen -composite #{f}")
      system("magick #{f} -gravity center \\( -clone 0 -crop 880x880+0+0 -resize \"#{baguette[0]}x#{baguette[0]}+0+0\" \\) -geometry +0+0 -composite #{f}")
      puts "#{f}\nBaguette => #{baguette[0]}\n----------------------\n\n"

    end
  end
end

def homothetie_calc

  lang = {
    fr: {
      premium: "Cadre qualité premium",
      plexiglas: "Avec plexiglas protecteur",
      frame: "CADRE",

      finition: {
        wood: {
          white: "Cadre bois blanc",
          black: "Cadre bois noir",
          oak: "Cadre bois chêne",
          white_large: "Cadre bois blanc large",
          black_large: "Cadre bois noir large",
          white_vintage_large: "Cadre bois blanc vintage",
          black_vintage_large: "Cadre bois noir vintage large",
          gold_ancient_large: "Cadre doré antique large",
          gold_vintage: "Cadre doré vintage"
        },

        alu: {
          black: "Cadre aluminium noir mat",
          gold: "Cadre aluminium doré",
          silver: "Cadre aluminium argenté",
          copper: "Cadre aluminium cuivré"
        }
      }
    },

    en: {
      premium: "Premium quality frame",
      plexiglas: "With protective plexiglas",
      frame: "FRAME",

      finition: {
        wood: {
          white: "White wood frame",
          black: "Black wood frame",
          oak: "Oak wood frame",
          white_large: "large white wood frame",
          black_large: "large black wood frame",
          white_vintage_large: "Vintage wide white wood frame",
          black_vintage_large: "Vintage wide black wood frame",
          gold_ancient_large: "Ancient large gold frame",
          gold_vintage: "vintage gold frame"
        },

        alu: {
          black: "Mat black aluminium frame",
          gold: "Golden aluminium frame",
          silver: "Silver aluminium frame",
          copper: "Copper-plated aluminium frame"
        }
      }
    },

    de: {
      premium: "Hochwertiger Rahmen",
      plexiglas: "Mit schützendem Plexiglas",
      frame: "RAHMEN",

      finition: {
        wood: {
          white: "Weißer Holzrahmen",
          black: "Schwarzer Holzrahmen",
          oak: "Holzrahmen Eiche",
          white_large: "Weißer Holzrahmen breit",
          black_large: "Schwarzer Holzrahmen breit",
          white_vintage_large: "Weißer Holzrahmen breit Vintage",
          black_vintage_large: "Schwarzer Holzrahmen breit Vintage",
          gold_ancient_large: "Breiter antiker goldener Holzrahmen",
          gold_vintage: "Goldener Vintage Holzrahmen"
        },

        alu: {
          black: "Mattschwarzer Aluminiumrahmen",
          gold: "Goldener Aluminiumrahmen",
          silver: "Silberner Aluminiumrahmen",
          copper: "Kupferfarbener Aluminiumrahmen"
        }
      }
    },

    es: {
      premium: "Marco de alta calidad",
      plexiglas: "Con plexiglás de protección",
      frame: "MARCO",

      finition: {
        wood: {
          white: "Marco de alta calidad",
          black: "Marco de madera negro",
          oak: "Marco de madera de roble",
          white_large: "Gran marco de madera blanca",
          black_large: "Gran marco de madera negra",
          white_vintage_large: "Gran marco blanco de madera vintage",
          black_vintage_large: "Gran marco negro de madera vintage",
          gold_ancient_large: "Gran marco de madera dorada antigua",
          gold_vintage: "Marco de madera dorada vintage"
        },

        alu: {
          black: "Marco de aluminio negro mate",
          gold: "Marco de aluminio dorado",
          silver: "Marco de aluminio plateado",
          copper: "Marco de aluminio cobrizo"
        }
      }
    },

    it: {
      premium: "Telaio di alta qualità",
      plexiglas: "Con plexiglass protettivo",
      frame: "TELAIO",

      finition: {
        wood: {
          white: "Telaio in legno bianco",
          black: "Telaio in legno nero",
          oak: "Telaio in legno di quercia",
          white_large: "Grande cornice in legno bianco",
          black_large: "Grande cornice in legno nero",
          white_vintage_large: "Grande cornice in legno bianco vintage",
          black_vintage_large: "Grande cornice in legno nero vintage",
          gold_ancient_large: "Cornice larga in legno dorato antico",
          gold_vintage: "Cornice in legno dorato vintage"
        },

        alu: {
          black: "Telaio in alluminio nero opaco",
          gold: "Telaio in alluminio placcato oro",
          silver: "Telaio in alluminio argento",
          copper: "Telaio in alluminio ramato"
        }
      }
    },

    nl: {
      premium: "Frame van topkwaliteit",
      plexiglas: "Met beschermend plexiglas",
      frame: "FRAME",

      finition: {
        wood: {
          white: "Wit houten frame",
          black: "Zwart houten frame",
          oak: "Eiken houten frame",
          white_large: "Grote witte houten lijst",
          black_large: "Grote zwarte houten lijst",
          white_vintage_large: "Vintage grote witte houten lijst",
          black_vintage_large: "Vintage grote zwarte houten lijst",
          gold_ancient_large: "Grote antieke gouden houten lijst",
          gold_vintage: "Vintage vergulde houten lijst"
        },

        alu: {
          black: "Matzwart aluminium frame",
          gold: "Verguld aluminium frame",
          silver: "Zilverkleurig aluminium frame",
          copper: "Verkoperd aluminium frame"
        }
      }
    },

    sv: {
      premium: "Högkvalitativ ram",
      plexiglas: "Med skyddande plexiglas",
      frame: "RAM",

      finition: {
        wood: {
          white: "Vit träram",
          black: "Svart träram",
          oak: "Ek träram",
          white_large: "Stor vit träram",
          black_large: "Stor svart träram",
          white_vintage_large: "Vintage stor vit träram",
          black_vintage_large: "Vintage stor svart träram",
          gold_ancient_large: "Stor träram i antikt guld",
          gold_vintage: "Vintage förgylld träram"
        },

        alu: {
          black: "Matt svart aluminiumram",
          gold: "Förgylld aluminiumram",
          silver: "Silverfärgad aluminiumram",
          copper: "Kopparpläterad aluminiumram"
        }
      }
    }
  }

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

      puts "\n--------------------------------------------\n\nFile                => #{f}\nDestination Folder  => #{new_size + "/"}\nNew width           => #{new_width}\nNew ratio           => #{ratio}\n\nProcessing          => #{new_name_temp}\nMaterial            => #{material}\nColor               => #{color}\n"
      mask_name = "FRAME/#{new_size + "-" + new_name}-MASK.jpg"

      x=`exiftool -s -s -s -comment #{f}`
      x = x.to_f.round
      x = 1000 - x
      x /= 2

      puts "Baguette's width    => #{x}px"

      system("magick -size 1000x1000 xc:white \
              -liquid-rescale #{ratio}x100% \
              -shave #{x}x#{x} \
              -mattecolor black -frame #{x} \
              #{mask_name}")

      puts "Mask created        => #{mask_name}\n\n"

      locales = %i(fr en de es it nl sv)
      locales.each do |locale|

        placeholder_finition  = lang[locale][:finition][material.to_sym][[color, style, thickness].reject(&:nil?).join('_').to_sym].upcase
        placeholder_premium   = lang[locale][:premium].upcase
        placeholder_plexiglas = lang[locale][:plexiglas].upcase

        system("magick #{f} -liquid-rescale #{ratio}x100% \
                -font GTEestiProText-Bold -pointsize 100 -kerning 2 \
                -gravity center -fill '#04150E' -annotate +0-50 #{new_size} \
                -background none -size 400x -font GTEestiProText-Medium -pointsize 23 -kerning 3 -fill '#04150E' \
                caption:'#{placeholder_finition}' \
                -gravity center -geometry +0+20 -compose over -composite \
                -background none -fill '#04150E' -font GTEestiProText-Medium -pointsize 20 -interline-spacing 6 -kerning 2 \
                -gravity center -annotate +0-300 '#{placeholder_premium}\n#{placeholder_plexiglas}' \
                LOGO.png -geometry +0+275 -composite \
                #{new_name_temp}")

        system("composite -compose Screen REFLECTION/#{rand(1..3)}.png #{new_name_temp} #{mask_name} #{new_name_temp}")

        # resize_format = %w(1000 700 450)
        # resize_format.each do |resize|
        #   new_path_name = "FRAME/#{new_size + "/" + resize + "x" + resize + "/" + new_size + "-" + new_name + "-" + locale.to_s}.jpg"
        #   # system("yoga image -v --resize #{resize + "x" + resize} --jpeg-quality 90 #{new_name_temp} #{new_path_name}")
        #   system("magick #{new_name_temp} -resize x#{resize} #{new_path_name}") # no optimisation
        #   puts "Optimised - #{resize + "x" + resize}"
        # end

        # # DLIP / BLOB

        # new_dlip_path_name = "FRAME/#{new_size + "/1x1/" + new_size + "-" + new_name + "-" + locale.to_s}.jpg"
        # system("magick #{new_name_temp} -strip \
        #         -resize x450 \
        #         -quality 20% \
        #         -blur 5x3 \
        #         -interlace plane \
        #         #{new_dlip_path_name}")
        # puts "Optimised - 1x1"

        # puts "\n[#{locale.upcase}] - #{new_size} #{placeholder_finition} - Image processed !\n\n"
      end
    end
  end
end

homothetie_calc
