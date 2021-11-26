Async websocket to PostgreSQL proxy.

Usage
-----

.. code-block:: python

    from pgwebsocket import PgWebsocket
    
    app = PgWebsocket("")
    
    @app.on_connect
    async def _on_connect(ctx):
        await ctx.execute("LISTEN clients;")
    
    @app.on_disconnect
    async def _on_disconnect(ctx):
        await ctx.execute("UNLISTEN clients;")
    
    if __name__ == '__main__':
        app.run()

