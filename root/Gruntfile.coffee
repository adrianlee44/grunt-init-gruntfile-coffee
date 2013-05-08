module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig{% if (min) { %}
    # Metadata.{% if (package_json) { %}
    pkg: grunt.file.readJSON "package.json"

    banner:
      """/*! <%= pkg.title || pkg.name %>
        * v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>
        <%= pkg.homepage ? "* " + pkg.homepage %>"
        * Copyright <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;
        * Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %>
        */
      """{% } else { %}
    meta:
      version: "0.1.0"

    banner:
      """/*! PROJECT_NAME
        * v<%= meta.version %> - <%= grunt.template.today("yyyy-mm-dd") %>
        * http://PROJECT_WEBSITE/
        * Copyright <%= grunt.template.today("yyyy") %> YOUR_NAME;
        * Licensed MIT
        */
      """{% } } %}

    # Task configuration.{% if (min) { %}
    uglify:
      options:
        banner: "<%= banner %>"
      dist:
        src: "dist/{%= file_name %}.js"
        dest: "dist/{%= file_name %}.min.js"
    {% } %}

    coffeelint:
      gruntfile: ["Gruntfile.coffee"]
      lib_test: ["{%= lib_dir %}/**/*.coffee", "{%= test_dir %}/**/*.coffee"]

    {% if (dom) { %}
    {%= test_task %}:
      files: ["{%= test_dir %}/**/*.html"]
    {% } else { %}
    {%= test_task %}:
      files: ["{%= test_dir %}/**/*_test.coffee"]
    {% } %}

    watch:
      gruntfile:
        files: "<%= coffeelint.gruntfile %>"
        tasks: ["coffeelint:gruntfile"]
      lib_test:
        files: "<%= coffeelint.lib_test %>"
        tasks: ["coffeelint:lib_test", "coffee", "{%= test_task %}"]

    coffee:
      dist:
        files:
          "dist/{%= file_name %}.js": ["{%= lib_dir %}/**/*.coffee"]

  # These plugins provide necessary tasks.{% if (min) { %}
  grunt.loadNpmTasks "grunt-contrib-uglify"{% } %}
  grunt.loadNpmTasks "grunt-contrib-{%= test_task %}"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"

  # Default task.
  grunt.registerTask "default", ["coffeelint", "coffee", "{%= test_task %}"{%= min ? ", \"uglify\"" : "" %}]