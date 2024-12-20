Rails.application.routes.draw do
  root 'pokemons#index'
  get 'pokemons', to: 'pokemons#index'
  get 'pokemons/:id', to: 'pokemons#show', as: 'pokemon'
end