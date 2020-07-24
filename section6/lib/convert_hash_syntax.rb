def convert_hash_syntax(old_syntax)
  old_syntax.gsub(/:(\w+) *=> */, '\1: ')
end

# \w は [A-Za-z0-9_] と同じ意味。
# 今回使いたいのは、 [a-z0-9_] と \w からA-Zを除いたパターン。特に問題ない。
# * は0回以上の繰り返し
# \1 は一番目にキャプチャされた奴