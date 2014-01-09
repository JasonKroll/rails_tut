class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(microposts_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
      # flash[:error] = "Micropost create!"
      # redirect_to root_url
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
   
    def microposts_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      # use find_by instead of find because the latter raises an exception
      redirect_to root_url if @micropost.nil?
    end
end
