currencies = { 'japan' => 'yen', 'us' => 'dollar', 'india' => 'rupee' }

currencies.each do |key, value|
  p "#{key} : #{value}"
end

currencies.each do |key_value|
  p "#{key_value[0]} : #{key_value[1]}"
end

p 'apple'.methods
p :apple.methods

currencies = { japan: 'yen', us: 'dollar', india: 'rupee' }
p currencies

currencies = { japan: :yen, us: :dollar, india: :rupee }
p currencies

def buy_burger(menu, drink, potato)
  # ハンバーガー購入
  if drink
    # ドリンク購入
  end
  if potato
    # ポテト購入
  end
end

buy_burger('cheese', true, true)

def buy_burger(menu, drink: drink, potato: potato)
  # ハンバーガー購入
  if drink
    # ドリンク購入
  end
  if potato
    # ポテト購入
  end
end
buy_burger('cheese', drink: true, potato: true)

currencies = { japan: 'yen', us: 'dollar', india: 'rupee' }
p currencies.keys

p currencies.has_key?(:japan)
p currencies.has_key?(:italy)

currencies = { japan: 'yen', us: 'dollar', india: 'rupee' }
hoge = { hoge: 'fuga', **currencies }
p hoge

def buy_burger(menu, options = {})
  p options
end

buy_burger('cheese', { 'drink' => true, 'potato' => true } )
buy_burger('cheese', 'drink' => true, 'potato' => true)
buy_burger('cheese', drink: true, potato: true)

currencies = { 'japan' => 'yen', 'us' => 'dollar', 'india' => 'rupee' }
p currencies.to_a

currencies = [["japan", "yen"], ["us", "dollar"], ["india", "rupee"]]
p currencies.to_h 

hoge = %i(apple orange melon)
p hoge

string = 'apple'
symbol = :apple

p string == symbol
p string.to_sym == symbol
p string == symbol.to_s
