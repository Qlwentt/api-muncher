class Recipe


  attr_reader :name, :id, :health_labels, :ingredients, :url, :servings, :nutrients, :photo_url

  def initialize(recipe_hash)
    @name = recipe_hash[:name]
    @id = recipe_hash[:id]
    @health_labels = recipe_hash[:health_labels]
    @ingredients = recipe_hash[:ingredients]
    @url = recipe_hash[:url]
    @servings = recipe_hash[:servings].to_f
    @nutrients = recipe_hash[:nutrients]
    @photo_url = recipe_hash[:photo_url]
  end

  def self.make_recipes_from_api(recipe_array)
    #puts recipe_array.first.class
    # puts recipe_array.class==Array 
    raise ArgumentError unless recipe_array.class == Array || recipe_array.class == WillPaginate::Collection
    raise ArgumentError unless recipe_array.all? { |item|item.class==Hash   }

    recipes=[]

    recipe_array.each_with_index do |recipe_hash, index|
      recipes<<Recipe.new({
        name: recipe_hash['recipe']['label'],
        id: (index+1).to_s,
        health_labels: recipe_hash['recipe']['healthLabels'],
        ingredients: Ingredient.make_ingredients_from_api(recipe_hash['recipe']['ingredients']),
        url: recipe_hash['recipe']['url'],
        servings: recipe_hash['recipe']['yield'],
        nutrients: Nutrient.make_nutrients_from_api(recipe_hash['recipe']['totalNutrients']),
        photo_url: recipe_hash['recipe']['image']

         })
    end
    return recipes
  end
end

