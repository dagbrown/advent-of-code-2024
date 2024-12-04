#!/usr/bin/ruby

class Wordsearch
  def initialize(text)
    @letters=text.split(/\n/).map { |w| w.split(//) }
  end

  def width
    @letters[0].length
  end

  def height
    @letters.length
  end

  def letter(x,y)
    if x >= 0 and y >= 0 and x < width and y < height then
      @letters[x][y]
    else
      ""
    end
  end

  def x_at(x,y)
    [ letter(x-1,y-1) + letter(x,y) + letter(x+1,y+1),
      letter(x+1,y-1) + letter(x,y) + letter(x-1,y+1) ]
  end

  def x_mas_at?(x,y)
    ecks = x_at(x,y)
    ( ecks[0] == "MAS" and ecks[1] == "MAS" ) or
    ( ecks[0] == "MAS" and ecks[1] == "SAM" ) or
    ( ecks[0] == "SAM" and ecks[1] == "SAM" ) or
    ( ecks[0] == "SAM" and ecks[1] == "MAS" )
  end

  def ewordat(x,y,len)  (0..len-1).map { |i| letter( x+i , y   ) }.inject :+ end
  def wwordat(x,y,len)  (0..len-1).map { |i| letter( x-i , y   ) }.inject :+ end
  def nwordat(x,y,len)  (0..len-1).map { |i| letter( x   , y-i ) }.inject :+ end
  def swordat(x,y,len)  (0..len-1).map { |i| letter( x   , y+i ) }.inject :+ end
  def newordat(x,y,len) (0..len-1).map { |i| letter( x+i , y-i ) }.inject :+ end
  def sewordat(x,y,len) (0..len-1).map { |i| letter( x+i , y+i ) }.inject :+ end
  def nwwordat(x,y,len) (0..len-1).map { |i| letter( x-i , y-i ) }.inject :+ end
  def swwordat(x,y,len) (0..len-1).map { |i| letter( x-i , y+i ) }.inject :+ end

  def wordstarat(x,y,len)
    [
      ewordat(x,y,len),
      sewordat(x,y,len),
      swordat(x,y,len),
      swwordat(x,y,len),
      wwordat(x,y,len),
      nwwordat(x,y,len),
      nwordat(x,y,len),
      newordat(x,y,len)
    ]
  end

  def allstars(len)
    words = []
    (0..width-1).each do |x|
      (0..height-1).each do |y|
        words += wordstarat(x,y,len).find_all { |w| w.length == len }
      end
    end
    words
  end

  def occurencesof(word)
    allstars(word.length).grep(word).length
  end

  def exes
    my_exes = []
    (0..width-1).each do |x|
      (0..height-1).each do |y|
        my_exes << x_mas_at?(x,y)
      end
    end
    my_exes.find_all do |present| present end.length
  end
        
end

w = Wordsearch.new ARGF.read
puts "Answer to part 1:", w.occurencesof("XMAS")
puts "Answer to part 2:", w.exes
