module Step5sHelper
   def index_select_info_class
    options = @current_user.department.majors.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
        <label for="select_major_id">专业</label>
        <select id="select_major_id" name="major_id style="margin:0px;padding:0px;float:none;>
          <option value='' >请选择专业...</option>
          <options>
        </select>
        <label for="select_class_id">班级</label>
        <select id="select_class_id" disabled="disabled" name="class_id" style="margin:0px;padding:0px;float:none;>
          <option value='' >请选择班级...</option>
        </select>
      <script>
        jQuery("#select_major_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_class_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "请选择班级...";
          select.options.add(option);
          if(v){
            jQuery.ajax({
              url: "/majors/classes_to_json",
              data: {id: v},
              type: "POST",
              success: function(data){
                var classes = Ext.util.JSON.decode(data);
                for(var i=0, l=classes.length; i<l; i++){
                  var option = document.createElement("option");
                  var u = classes[i];
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
    html.sub!("<options>",options)
  end
end
