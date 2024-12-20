require 'net/http'
require 'json'

class PokemonsController < ApplicationController
  def index
  end

  def show
    @pokemon_id_or_name = params[:id]
    Rails.logger.debug "Received id: #{@pokemon_id_or_name}"
    @pokemon_data = fetch_pokemon_data(@pokemon_id_or_name)
    if @pokemon_data.nil?
      flash[:alert] = "ポケモンが見つかりませんでした。"
      redirect_to root_path
    else
      Rails.logger.debug "Fetched Pokemon Data: #{@pokemon_data}"
    end
  end

  private

  def fetch_pokemon_data(id_or_name)
    url = URI("https://pokeapi.co/api/v2/pokemon/#{id_or_name}/")
    response = Net::HTTP.get(url)
    JSON.parse(response) rescue nil
  end
end