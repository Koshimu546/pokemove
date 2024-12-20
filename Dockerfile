# Rubyの公式イメージをベースに使用
FROM ruby:3.3.5-slim

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をインストール
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  nodejs

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# Gemsをインストール
RUN bundle install && \
  rm -rf ~/.bundle/ "/usr/local/bundle"/ruby/*/cache "/usr/local/bundle"/ruby/*/bundler/gems/*/.git

# アプリケーションコードをコピー
COPY . .

# スクリプト内の ruby.exe を ruby に置き換え
RUN sed -i 's/ruby.exe/ruby/' bin/rails

# ブーツナップをプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# アセットをプリコンパイル
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ポート3000を公開
EXPOSE 3000

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]