class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy reserve cancel_reserve purchase cancel_purchase]

  # GET /books or /books.json
  def index
    @books = Book.where(status: :available)
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reserve
    respond_to do |format|
      if @book.update!(status: 1, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'Book was successfully reserved!'
      else
        flash.now[:notice] = 'Book could not be reserved'
      end
    end
  end

  def cancel_reserve
    respond_to do |format|
      if @book.update!(status: 0, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'The book is no longer reserved!'
      else
        flash.now[:notice] = 'The reserve could not be cancelled'
      end
    end
  end

  def purchase
    respond_to do |format|
      if @book.update!(status: 2, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'The book was purchased!'
      else
        flash.now[:notice] = 'The book could not be purchased'
      end
    end
  end

  def cancel_purchase
    respond_to do |format|
      if @book.update!(status: 0, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'The purchase was cancelled!'
      else
        flash.now[:notice] = 'The purchase could not be cancelled!'
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :status, :isbn)
    end
end
