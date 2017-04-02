<% loop $BuildingsData %>


    <script type='text/javascript'>

        // floor_overlay

        /**
        $('.property-selector-list .floor').entwine({
            expand: function() {
                this.animate({height: 100}, {queue: false})
            },
            collapse: function() {
                this.animate({height: 45}, {queue: false})
            },
            onmouseenter: function(){
                this.expand();
            },
            onmouseleave: function(){
                this.collapse();
            }
        })
        **/

        $('.property-selector-list .floor').entwine({
            onmatch: function(){
                this.css({height: 45, width: 200, clear: 'left'});
            },
            expand: function() {
                this.animate({height: 100}, {queue: false})
            },
            collapse: function() {
                this.animate({height: 45}, {queue: false})
            },
            onmouseenter: function(){
                this.expand();
            },
            onmouseleave: function(){
                this.collapse();
            }
        })

        // override
        /**
        $('ul.horizontal li').entwine({
            onmatch: function(){
                this.css({height: 100, width: 45, clear: 'none'});
            },
            expand: function(){
                this.animate({width: 200}, {queue: false})
            },
            collapse: function(){
                this.animate({width: 45}, {queue: false})
            }
        })
        */


        // .property-selector-list .floor
        //         $('ul.lightens li').entwine({

        $('.property-selector-list.lightens .floor').entwine({
            Highlight: '#ced',

            onmouseenter: function(){
                this.animate({backgroundColor: this.getHighlight()}, {queue: false});
                this._super();
            },
            onmouseleave: function(){
                this.animate({backgroundColor: '#ccc'}, {queue: false});
                this._super();
            }
        })

    </script>



        <table class="table table-striped property-selector-list lightens">
        <thead>
        <tr>
            <th>#</th>
            <th>Header</th>
            <th>Header</th>
            <th>Header</th>
            <th>Header</th>
        </tr>
        </thead>

        <tbody>
            <% loop $Floors %>
                <% loop $Properties %>


                <tr>
                    <td class="floor lightens">$FloorTitle</td>
                    <td class="property">$Title</td>
                    <td>ipsum</td>
                    <td>dolor</td>
                    <td>sit</td>
                </tr>
                <% end_loop %>
            <% end_loop %>

        </tbody>
    </table>

<% end_loop %>
