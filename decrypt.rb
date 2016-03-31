ppm = File.open('encrypted.ppm')

3.times { ppm.readline }

enc = ppm.read.split(' ').map(&:to_i)

bytes = 0.upto(enc.length / 3 - 1).map do
  (enc.shift & 0b00000111) << 5\
  | (enc.shift & 0b00000011) << 3\
  | (enc.shift & 0b00000111)
end.pack('C*')

out = File.new('./tmp/output.txt', 'w')
out << bytes
out.close
