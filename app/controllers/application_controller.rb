# coding: utf-8
class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  protect_from_forgery

  # タブレット非スマートフォン判定
  before_filter :disable_mobile_view_if_tablet

  # BASIC認証
  http_basic_authenticate_with name: "playcast", password: "playcast1226" unless Rails.env.development?

  # ログイン認証
  before_filter :authorize

  # セッション有効期限延長
  before_filter :reset_session_expires

  private

  #-------------------------------#
  # disable_mobile_view_if_tablet #
  #-------------------------------#
  # タブレット非スマートフォン化
  def disable_mobile_view_if_tablet
    if request.mobile and request.mobile.tablet?
      disable_mobile_view!
    end
  end

  #-----------#
  # authorize #
  #-----------#
  # ログイン認証
  def authorize
    # セッション／トップコントローラ以外で
    if params[:controller] != "sessions" and params[:controller] != "top"
      # 未ログインであればルートヘリダイレクト
      if session[:user_id].blank?
        # リクエストURL保管
        session[:request_url] = request.url

        redirect_to "/auth/#{Settings.provider}"
      end
    end
  end

  #-----------------------#
  # reset_session_expires #
  #-----------------------#
  # セッション期限延長
  def reset_session_expires
    request.session_options[:expire_after] = 2.weeks
  end

  #--------------#
  # current_user #
  #--------------#
  def current_user
    @current_user ||= User.where( id: session[:user_id] ).first
  end

  helper_method :current_user
end
