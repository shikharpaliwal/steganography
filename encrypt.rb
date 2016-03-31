#!/usr/bin/env ruby
input_image_name = 'food'
output_image_name = 'encrypted_' + input_image_name

input_image_reader = File.open("./#{input_image_name}.ppm", 'r')
output_image_writer = File.new("./#{output_image_name}.ppm", 'w')

embed_text = '© TinyOwl Technology Pvt. Ltd., 2015. Unauthorized use and/or
  duplication of this material without express and written permission from
  this owner is strictly prohibited.Excerpts and links may be used, provided
  that full and clear credit is given to TinyOwl withappropriate and specific
  direction to the original content.

  '.unpack('C*').flatten

embed_text_length = embed_text.length

3.times { output_image_writer << input_image_reader.readline; }

offset = 0

loop do
  begin
    input_line = input_image_reader.readline
  rescue
    break
  end
  break unless input_line
  input_line = input_line.split(' ').map(&:to_i)
  0.upto(input_line.length / 3 - 1) do |x|
    byte = embed_text[offset % embed_text_length]
    pixel = x * 3
    # xxx0 0000 Red channel gets msb top 3 bits as the lsb
    input_line[pixel] = input_line[pixel] & 0xF8 | ((byte >> 5) & 0x7)
    # 000x x000 Green gets the next 2
    input_line[pixel + 1] = input_line[pixel + 1] & 0xFC | ((byte >> 3) & 0x3)
    # 0000 0xxx Blue gets lsb 3
    input_line[pixel + 2] = input_line[pixel + 2] & 0xF8 | (byte & 0x7)

    offset += 1
  end
  output_image_writer << input_line.join(' ') + "\n"
end
output_image_writer << "\n"

output_image_writer.close

`convert ./#{output_image_name}.ppm ./#{output_image_name}.jpeg`
