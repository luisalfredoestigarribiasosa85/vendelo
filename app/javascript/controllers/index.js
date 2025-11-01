// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import FlashController from "controllers/flash_controller"
application.register("flash", FlashController)
eagerLoadControllersFrom("controllers", application)
