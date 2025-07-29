require 'test_helper'
class ProductsControllerTest < ActionDispatch::IntegrationTest
    test 'render a list of products' do
        get products_path
        assert_response :success
        assert_select 'h1', 'Productos:'
    end

    test 'render a single product' do
        product = products(:PS4)
        get product_path(product)
        assert_response :success
        assert_select 'h1', product.title
    end

    test 'render a new product form' do
        get new_product_path
        assert_response :success
        assert_select 'h2', 'Añadir Producto'
        assert_select 'form'
    end

    test 'allow to create a new product' do
        assert_difference 'Product.count', 1 do
            post products_path, params: { product: { title: 'PS5', description: 'La nueva consola de Sony', price: 499.99 } }
        end
        assert_redirected_to products_path
        follow_redirect!
        assert_select 'div.alert', 'Producto creado exitosamente.'
        assert_equal flash[:notice], 'Producto creado exitosamente.'
    end

    test 'show error when creating product with invalid data' do
        assert_no_difference 'Product.count' do
            post products_path, params: { product: { title: '', description: '', price: -10 } }
        end
        assert_response :unprocessable_entity
        assert_select 'div.alert', 'Error al crear el producto.'
    end

    test 'render an edit product form' do
        product = products(:PS4)
        get edit_product_path(products(:PS4))
        assert_response :success
        assert_select 'h2', 'Editar Producto'
        assert_select 'form'
    end

    test 'allow to update a product' do
        product = products(:PS4)
        patch product_path(product), params: { product: { title: 'PS4 Pro', description: 'Versión mejorada de PS4', price: 399.99 } }
        assert_redirected_to products_path
        follow_redirect!
        assert_select 'div.alert', 'Producto actualizado exitosamente.'
        assert_equal flash[:notice], 'Producto actualizado exitosamente.'
    end

    test 'show error when updating product with invalid data' do
        product = products(:PS4)
        patch product_path(product), params: { product: { title: '', description: '', price: -10 } }
        assert_response :unprocessable_entity
        assert_select 'div.alert', 'Error al actualizar el producto.'
    end

    test 'allow to delete a product' do
        product = products(:PS4)
        assert_difference 'Product.count', -1 do
            delete product_path(product)
        end
        assert_redirected_to products_path
        follow_redirect!
        assert_select 'div.alert', 'Producto eliminado exitosamente.'
        assert_equal flash[:notice], 'Producto eliminado exitosamente.'
    end

    test 'show error when deleting a product fails' do
        product = products(:PS4)
        # Simulate failure by preventing destroy via a before_destroy callback
        Product.class_eval do
            before_destroy :prevent_destroy_for_test, prepend: true
            def prevent_destroy_for_test
                throw(:abort)
            end
        end

        delete product_path(product)
        assert_redirected_to products_path
        follow_redirect!
        assert_select 'div.alert', 'Error al eliminar el producto.'

        # Clean up the callback so it doesn't affect other tests
        Product.reset_callbacks(:destroy)
    end
end