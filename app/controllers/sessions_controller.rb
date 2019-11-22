class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # ログインフォームから受け取ったemailの値を使ってユーザーオブジェクトを検索しuserに代入。
    if user && user.authenticate(params[:session][:password]) # has_secure_passwordの機能であるauthenticateメソッドを利用して認証の実行。
      # ログイン後にユーザー情報ページにリダイレクトする。
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
end
