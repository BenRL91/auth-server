class ItemsController < ApplicationController
  before_action :authenticate!
  before_action :set_collection!

  def create
    parse_json!
    @item = @collection.items.new(data: @data)
    if @item.save
      render "create.json.jbuilder", status: :created
    else
      render "errors.json.builder", status: :unprocessable_entity
    end
  end

  def index
    @items = @collection.items
    render "index.json.jbuilder", status: :ok
  end

  def show
    @item = @collection.items.find(params[:id])
    render "show.json.jbuilder", status: :ok
  end

  def update
    parse_json!
    @item = @collection.items.find(params[:id])
    if @item.update(@data)
      render "show.json.jbuilder", status: :accepted
    else
      render "errors.json.jbuilder", status: :unprocessable_entity
    end
  end

  def destroy
    @item = @collection.items.find(params[:id])
    render json: {}, status: :no_content
  end

  private
  def set_collection!
    @collection = current_user.collections.find_or_create_by(title: params[:collection])
  end

  # This is so damn purple.
  def parse_json!
    @data = JSON.parse(request.body.read)
    request.body.rewind
  end
end
