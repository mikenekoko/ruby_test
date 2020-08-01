module Effects
  def self.reverse
    # ブロックで呼ばれるので、wordsに Ruby is fun!が入る
    ->(words) do
      words.split(' ').map(&:reverse).join(' ')
    end
  end

  def self.echo(rate)
    ->(words) do
      # 1文字ずつ取り出し、空白以外はrateの数だけ繰り返す。最後にjoinする
      words.chars.map { |c| c == ' ' ? c : c * rate }.join
    end
  end

  def self.loud(level)
    ->(words) do
      words.split(' ').map { |word| word.upcase + '!' * level }.join(' ')
    end
  end
end