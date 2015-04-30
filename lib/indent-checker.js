var IndentChecker = {
  getLinesByType: function( input ) {
    return input.split( /\n/ ).reduce( function( types, line, index ) {
      var type = IndentChecker.getLineType( line );
      types[ type ] = types[ type ] || [];
      types[ type ].push( { line: line, number: index + 1 } );
      return types;
    }, {} );
  },

  getLineType: function( line ) {
    if ( line.substr( 0, 1 ).match( /\t/ ) ) {
      return 'tabs';
    } else if ( line.substr( 0, 1 ).match( /\s/ ) ) {
      return 'spaces';
    }
    return 'none';
  },

  getMostCommonIndentType: function( input ) {
    var types = IndentChecker.getLinesByType( input );
    return Object.keys( types ).reduce( function( prev, type ) {
      var count = types[ type ].length;
      if ( type === 'none' ) {
        prev = prev;
      } else if ( count === prev.count ) {
        prev = { type: 'none', count: count };
      } else if ( count > prev.count ) {
        prev = { type: type, count: count };
      }
      return prev;
    }, { type: 'none', count: 0 } ).type;
  },

  getLinesWithLessCommonType: function( input ) {
    var types = IndentChecker.getLinesByType( input );
    var mostCommonType = IndentChecker.getMostCommonIndentType( input );
    if ( mostCommonType === 'none' ) { return []; }
    return Object.keys( types ).reduce( function( lines, type ) {
      if ( type !== mostCommonType && type !== 'none' ) {
        lines = lines.concat( types[ type ].map( function( line ) {
          return line.number;
        } ) );
      }
      return lines;
    }, [] );
  }
};

module.exports = IndentChecker;
