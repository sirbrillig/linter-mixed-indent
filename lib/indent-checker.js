var IndentChecker = {
  getLinesByType: function( input ) {
    return input.split( /\n/ ).reduce( function( types, line ) {
      var type = IndentChecker.getLineType( line );
      types[ type ] = types[ type ] || [];
      types[ type ].push( line );
      return types;
    }, {} );
  },

  getLineType: function( line ) {
    if ( line.substr( 0, 1 ).match( /\t/ ) ) {
      return 'tabs';
    }
    return 'spaces';
  },

  getMostCommonIndentType: function( input ) {
    var types = IndentChecker.getLinesByType( input );
    return Object.keys( types ).reduce( function( prev, type ) {
      var count = types[ type ].length;
      if ( count === prev.count ) {
        prev = { type: 'spaces', count: count };
      } else if ( count > prev.count ) {
        prev = { type: type, count: count };
      }
      return prev;
    }, { type: 'spaces', count: 0 } ).type;
  }
};

module.exports = IndentChecker;
