import Ember from 'ember';

var Mixin = Ember.Mixin.create({

    flashMessage: null,

    flashLevel: 'alert',

    flash: function( message, level ) {
        this.setProperties({
            flashMessage: message,
            flashLevel: level
        });
    },

    flashBox: Ember.View.extend({

        template: Ember.Handlebars.compile( '{{#if controller.flashMessage}}<div data-alert {{bind-attr class=":alert-box controller.flashLevel"}}>{{controller.flashMessage}}<a href="#" class="close">&times;</a></div>{{/if}}' )

    })

});

export default Mixin;