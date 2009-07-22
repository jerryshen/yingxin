module BedsHelper
  def select_room(name="room_id")
    options = Building.all.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
      <p>
        <label for="select_building_id">大楼</label>
        <select id="select_building_id" class="required" name="building_id">
          <option value='' >请选择大楼...</option>
          <options>
        </select>
      </p>
      <p>
        <label for="select_room_id">宿舍号</label>
        <select id="select_room_id" disabled="disabled" name="<name>" class="required">
          <option value='' >请选择宿舍号...</option>
        </select>
      </p>
      <script>
        jQuery("#select_building_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_room_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "请选择宿舍号...";
          select.options.add(option);
          if(v){
            jQuery.ajax({
              url: "/buildings/rooms_to_json",
              data: {id: v},
              type: "POST",
              success: function(data){
                var rooms = Ext.util.JSON.decode(data);
                for(var i=0, l=rooms.length; i<l; i++){
                  var option = document.createElement("option");
                  var u = rooms[i];
                  option.setAttribute("value",u.id);
                  option.text = u.name;
                  select.options.add(option);
                }
                select.disabled = false;
              }
            })
          }else{
            select.disabled = true;
          }
        })
      </script>
    }
    html.sub!("<options>",options).sub!("<name>",name)
  end
end
