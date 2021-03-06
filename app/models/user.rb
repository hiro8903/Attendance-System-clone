class User < ApplicationRecord
  # 存在性（presence）,長さの検証（length）,フォーマットの検証（format）,一意性の検証（unique）
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 現実的に実践可能な正規表現を定数として定義
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX }, # formatというオプション
                    uniqueness: true
  # has_secure_password は入力されたパスワードをそのままの文字列ではなく、
  # ハッシュ化（入力されたデータ（パスワード）を元に戻せないデータにする処理）
  # した状態の文字列でデータベースに保存する。
  # この機能を利用するにはbcryptと言うgemをインストールし、
  # モデルにpassword_digestというカラムを含める必要がある。
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

    # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  class User < ApplicationRecord
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    # 複数ブラウザでログインしていた場合に片方だけログアウトし、もう片方でブラウザを終了させ、再度開いた際に発生するバグ対策。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token) # トークンがダイジェストと一致すればtrueを返します。
  end

  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end
end

end
