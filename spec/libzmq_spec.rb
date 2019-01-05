require 'spec_helper'

describe LibZMQ do

  it "exposes basic query methods" do
    [:zmq_version, :zmq_errno, :zmq_strerror].each do |method|
      expect(LibZMQ).to respond_to(method)
    end
  end

  it "exposes initialization and context methods" do
    [:zmq_init, :zmq_term, :zmq_ctx_new,
     :zmq_ctx_destroy, :zmq_ctx_set, :zmq_ctx_get].each do |method|
      expect(LibZMQ).to respond_to(method)
    end
  end

  it "exposes the message API" do
    [:zmq_msg_init, :zmq_msg_init_size, :zmq_msg_init_data,
     :zmq_msg_close, :zmq_msg_data, :zmq_msg_size,
     :zmq_msg_copy, :zmq_msg_move, :zmq_msg_send,
     :zmq_msg_recv, :zmq_msg_more, :zmq_msg_get, :zmq_msg_set].each do |method|
      expect(LibZMQ).to respond_to(method)
    end
  end

  it "exposes the socket API" do
    [:zmq_socket, :zmq_setsockopt, :zmq_getsockopt,
     :zmq_bind, :zmq_connect, :zmq_close,
     :zmq_unbind, :zmq_disconnect, :zmq_recvmsg,
     :zmq_recv, :zmq_sendmsg, :zmq_send].each do |method|
      expect(LibZMQ).to respond_to(method)
    end
  end

  it "exposes the Device API" do
    expect(LibZMQ).to respond_to(:zmq_proxy)
  end

  it "exposes the Poll API" do
    expect(LibZMQ).to respond_to(:zmq_poll)
  end

  it "exposes the Monitoring API" do
    expect(LibZMQ).to respond_to(:zmq_socket_monitor)
  end

  if LibZMQ.version3?

    describe '.terminate_context' do
      it 'calls the 3.x zmq_ctx_destroy function' do
        context_dbl = double('context')

        expect(LibZMQ).to receive(:zmq_ctx_destroy).with(context_dbl)
        LibZMQ.terminate_context(context_dbl)
      end
    end

  elsif LibZMQ.version4?

    describe '.terminate_context' do
      it 'calls the 4.x zmq_ctx_destroy function' do
        context_dbl = double('context')

        expect(LibZMQ).to receive(:zmq_ctx_term).with(context_dbl)
        LibZMQ.terminate_context(context_dbl)
      end
    end

  end
end
