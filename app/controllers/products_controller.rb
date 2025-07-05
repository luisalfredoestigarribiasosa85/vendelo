class ProductsController < ApplicationController
    def index
        @products = Product.all
    end
    def show
        @product = Product.find(params[:id])
        if @product.nil?
            redirect_to products_path, alert: "Producto no encontrado."
        end
    end
end