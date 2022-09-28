// This file is automatically compiled by Webpack, along with any other files
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "cocoon"   //cocoonを動かすための記述
import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import Rails from '@rails/ujs';
import TurbolinksAdapter from 'vue-turbolinks'

import App from '../app.vue'
import Insert from '../insert_bigs.vue'
import Smalls from '../insert_smalls.vue'
import Cards from '../insert_cards.vue'
import Explains from '../explain_btn.vue'
import Publics from '../public_btn.vue'


require('jquery') //jQeryに依存しているため、ないと動かないです
require("@rails/ujs")
require("turbolinks").start()
require("channels")

Turbolinks.start()
ActiveStorage.start()
window.Rails = Rails
Rails.start();
window.store = {}

Vue.config.devtools = true;
Vue.use(Vuex)
Vue.use(TurbolinksAdapter)

document.addEventListener("turbolinks:load", function() {
    var element = document.querySelector("#boards")
    if (element != undefined) {
        window.store.lists = JSON.parse(element.dataset.lists)
        window.store.id = JSON.parse(element.dataset.id)
        window.store.disabled = JSON.parse(element.dataset.disabled)
        window.store.public = JSON.parse(element.dataset.public)
        
        const app = new Vue({
            el: element,
            data: window.store,
            template: "<App :original_lists='lists' />",
            components: { App }
        })
    }
    var element2 = document.querySelector("#mode1")
    if (element2 != undefined) {
        
        const app = new Vue({
            el: element2,
            template: "<insert></insert>",
            data: window.store,
            components: { Insert }
        })
    }
    var element3 = document.querySelector("#mode2")
    if (element3 != undefined) {
        
        const app = new Vue({
            el: element3,
            template: "<smalls></smalls>",
            data: window.store,
            components: { Smalls }
        })
    }
    var element4 = document.querySelector("#mode3")
    if (element4 != undefined) {
        
        const app = new Vue({
            el: element4,
            template: "<cards></cards>",
            data: window.store,
            components: { Cards }
        })
    }
    var element5 = document.querySelector("#mode4")
    if (element5 != undefined) {
        
        const app = new Vue({
            el: element5,
            template: "<explains></explains>",
            data: window.store,
            components: { Explains }
        })
    }
    var element6 = document.querySelector("#mode5")
    if (element6 != undefined) {
        
        const app = new Vue({
            el: element6,
            template: "<publics></publics>",
            data: window.store,
            components: { Publics }
        })
    }
});