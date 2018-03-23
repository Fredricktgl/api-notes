class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    if @note.nil?
      render json: { error: 'Record not found' }, status: 404
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)

    if @note.save
      render :show, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if @note.update(note_params)
      render :show, status: :ok, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
  end

  def sync
    all_note = Note.all
    remove_rec = []
    all_note.each do |n|
      remove_rec << n.id
    end

    hashed_rec = []
    sync_hash.each do |note|
      hashed_rec << note[:id]
      if note[:id]
        Note.find(note[:id]).update(title: note[:title], body: note[:body])
      else
        Note.create(title: note[:title], body: note[:body])
      end
    end

    del_rec = remove_rec - hashed_rec
    del_rec.each do |del|
      Note.find(del).destroy
    end

    @notes = Note.all.sort_by &:created_at
    render json: @notes, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find_by(id: params[:id])
    end

    def sync_hash
      params.to_unsafe_hash[:message]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :body)
    end
end
