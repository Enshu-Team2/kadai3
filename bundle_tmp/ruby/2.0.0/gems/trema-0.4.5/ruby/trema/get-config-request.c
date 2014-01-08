/*
 * Copyright (C) 2008-2013 NEC Corporation
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */


#include "trema-ruby-utils.h"


extern VALUE mTrema;
VALUE cGetConfigRequest;


static VALUE
get_config_request_alloc( VALUE klass ) {
  buffer *get_config_request = create_get_config_request( get_transaction_id() );
  return Data_Wrap_Struct( klass, NULL, free_buffer, get_config_request );
}


/*
 * Creates a {GetConfigRequest} instance to query configuration parameters
 * from the switch.
 *
 * @overload initialize()
 *   @example
 *     GetConfigRequest.new
 *
 * @overload initialize(transaction_id)
 *   @example
 *     GetConfigRequest.new( 123 )
 *   @param [Integer] transaction_id
 *     An unsigned 32-bit integer number associated with this message.
 *
 * @overload initialize(options)
 *   @example
 *     GetConfigRequest.new( :xid => 123 )
 *     GetConfigRequest.new( :transaction_id => 123 )
 *   @param [Hash] options
 *     the options to create a message with.
 *   @option options [Number] :xid an alias to transaction_id.
 *   @option options [Number] :transaction_id
 *     An unsigned 32-bit integer number associated with this message.
 *     If not specified, an auto-generated value is set.
 *
 * @raise [ArgumentError] if transaction ID is not an unsigned 32-bit integer.
 * @raise [TypeError] if argument is not a Integer or a Hash.
 * @return [GetConfigRequest]
 *     an object that encapsulates the +OFPT_GET_CONFIG+ OpenFlow message.
 */
static VALUE
get_config_request_init( int argc, VALUE *argv, VALUE self ) {
  buffer *get_config_request;
  Data_Get_Struct( self, buffer, get_config_request );
  VALUE options = Qnil;


  if ( rb_scan_args( argc, argv, "01", &options ) == 0 ) {
    set_xid( get_config_request, get_transaction_id() );
  }
  else {
    if ( options == Qnil ) {
      set_xid( get_config_request, get_transaction_id() );
    }
    else if ( rb_obj_is_kind_of( options, rb_cInteger ) == Qtrue ) {
      validate_xid( options );
      set_xid( get_config_request, ( uint32_t ) NUM2UINT( options ) );
    }
    else {
      Check_Type( options, T_HASH );
      VALUE tmp = Qnil;
      VALUE xid = Qnil;

      tmp = rb_hash_aref( options, ID2SYM( rb_intern( "transaction_id" ) ) );
      if ( tmp != Qnil ) {
        xid = tmp;
      }
      tmp = rb_hash_aref( options, ID2SYM( rb_intern( "xid" ) ) );
      if ( tmp != Qnil ) {
        xid = tmp;
      }

      if ( xid != Qnil ) {
        validate_xid( xid );
        set_xid( get_config_request, ( uint32_t ) NUM2UINT( xid ) );
      }
      else {
        set_xid( get_config_request, get_transaction_id() );
      }
    }
  }

  return self;
}


/*
 * Transaction ids, message sequence numbers matching requests to replies.
 *
 * @return [Number] the value of transaction id.
 */
static VALUE
get_config_request_transaction_id( VALUE self ) {
  return get_xid( self );
}


void
Init_get_config_request() {
  mTrema = rb_define_module( "Trema" );
  cGetConfigRequest = rb_define_class_under( mTrema, "GetConfigRequest", rb_cObject );
  rb_define_alloc_func( cGetConfigRequest, get_config_request_alloc );
  rb_define_method( cGetConfigRequest, "initialize", get_config_request_init, -1 );
  rb_define_method( cGetConfigRequest, "transaction_id", get_config_request_transaction_id, 0 );
  rb_alias( cGetConfigRequest, rb_intern( "xid" ), rb_intern( "transaction_id" ) );
}


/*
 * Local variables:
 * c-basic-offset: 2
 * indent-tabs-mode: nil
 * End:
 */
