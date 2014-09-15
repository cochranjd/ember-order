module.exports = function( grunt ) {

    grunt.initConfig({

        pkg: grunt.file.readJSON( 'package.json' ),

        shell: {
            rebuildDatabase: {
                command: 'bin/rake db:reset'
            },

            buildEmber: {
                command: './build.sh'
            }
        }
    });

    grunt.loadNpmTasks( 'grunt-shell' );

    grunt.registerTask( 'default', [ 'shell:buildEmber' ]);
    grunt.registerTask( 'fresh', [ 'shell:rebuildDatabase', 'shell:buildEmber' ]);
}