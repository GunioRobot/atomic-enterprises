class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    @trusted = request.headers['HTTP_EVE_TRUSTED']

    if @trusted == "Yes"
	@eve_info =  
	    {
		:charName => request.headers['HTTP_EVE_CHARNAME'],
		:charId => request.headers['HTTP_EVE_CHARID'],
		:corpName => request.headers['HTTP_EVE_CORPNAME'],
		:corpId => request.headers['HTTP_EVE_CORPID'],
		:allianceName => request.headers['HTTP_EVE_ALLIANCENAME'],
		:allianceId => request.headers['HTTP_EVE_ALLIANCEID'],
		:regionName => request.headers['HTTP_EVE_REGIONNAME'],
		:solarSystem => request.headers['HTTP_EVE_SOLARSYSTEMNAME'],
		:stationName => request.headers['HTTP_EVE_STATIONNAME'],
		:corpRole => request.headers['HTTP_EVE_CORPROLE']
	    }
    end

  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
