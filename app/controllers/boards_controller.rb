class BoardsController < ApplicationController
  # before_action :set_board, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate_user!
  before_action :authenticate_user!, :except => [ :show, :index ]

def landingpage
  redirect_to '/boards'
end


def search
    @search_results_boards = Board.search_by_boards(params[:query])
end

  # GET /boards
  # GET /boards.json
  def index
    @boardToday = Board.where(created_at: Date.today..Date.today + 1)
    # @boards = Board.all
    if user_signed_in?
      @user = User.find(current_user.id)
      @boardToday = Board.where(created_at: Date.today..Date.today + 1)
  # the respond include user model so we can access data from user
      respond_to do |format|
        format.json {
          render :json => @boardsToday,
          include: :user
        }

      format.html
    end

    # @boardHistory = Board.where(created_at: 1.week.ago..Date.today + 1)

  else redirect_to '/users/sign_in'
  end
  end

  def archive
    # @boardHistory = Board.where(created_at: 1.week.ago..Date.today + 1)
    # @boards = Board.all
    if user_signed_in?
      @user = User.find(current_user.id)
  # the respond include user model so we can access data from user
      respond_to do |format|
        format.json {
          render :json => @boards,
          include: :user
        }

      format.html
    end

# @search is an instance variable. This part is accessing BoardSearch model, and create new instances of that and is gonna pass in the search parameters, then calling scope method on search. Scope is defined in class of BoardSearch
    @search = BoardSearch.new(params[:search])
    @boards = @search.scope

    # @boardHistory = Board.where(created_at: 1.week.ago..Date.today + 1)
  else redirect_to '/users/sign_in'
  end
  end



  # GET /boards/1
  # GET /boards/1.json
  def show
    @board = Board.find(params[:id])
  end

  # GET /boards/new
  def new
    @board = Board.new
    @user = current_user.id
    # respond_modal_with @board
    puts @user
  end


  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
    if @board.user == current_user
      return
    else
      render plain: "You cannot edit your team mate's post!"
    end
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    @boards = Board.all
    @board.user = current_user
    # @board = Board.create(board_params)
    # respond_modal_with @board, location: boards_path
    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
  def update
    @board = Board.find(params[:id])
    @board.user == current_user
      respond_to do |format|
        if @board.update(board_params)
          format.html { redirect_to @board, notice: 'Board was successfully updated.' }
          format.json { render :show, status: :ok, location: @board }
        else
          format.html { render :edit }
          format.json { render json: @board.errors, status: :unprocessable_entity }
        end
      end
  end


  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board = Board.find(params[:id])
    if @board.user == current_user
      @board.destroy
      respond_to do |format|
        format.html { redirect_to boards_url, notice: 'Board was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      render plain: "You cannot delete your team mate's entry"
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_board
    @board = Board.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def board_params
    params.require(:board).permit(:accomplishment, :challenges, :task, :resources)
  end

end