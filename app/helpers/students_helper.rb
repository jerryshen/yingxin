module StudentsHelper
def select_class(major_id, class_id)
    options = Department.find(:all, :conditions => ["de_type =?",true]).collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
        <p>
        <label for="select_department_id">院系</label>
        <select id="select_department_id" class="required" name="department_id">
          <option value='' >选择院系...</option>
          <options>
        </select>
      </p>
      <p>
        <label for="select_major_id">专业</label>
        <select id="select_major_id" disabled="disabled" class="required" name="student[major_id]">
          <option value='' >选择专业...</option>
          <major_options>
        </select>
      </p>
      <p>
        <label for="select_class_id">班级</label>
        <select id="select_class_id" disabled="disabled" name="student[info_class_id]" class="required">
          <option value='' >选择班级...</option>
          <class_options>
        </select>
      </p>
      <script>
        jQuery("#select_department_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_major_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "选择专业...";
          select.options.add(option);
          if(v){
            jQuery.ajax({
              url: "/departments/majors_to_json",
              data: {id: v},
              type: "POST",
              success: function(data){
                var majors = Ext.util.JSON.decode(data);
                for(var i=0, l=majors.length; i<l; i++){
                  var option = document.createElement("option");
                  var u = majors[i];
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
        });
        <set_major_id>
      </script>
      <script>
        jQuery("#select_major_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_class_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "选择班级...";
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
        });
        <set_class_id>
      </script>
    }
    html.sub!("<options>",options)
    if major_id
      major = Major.find(major_id)
      sel_major_options = major.department.majors.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
      set = "var sel_major = document.getElementById('select_major_id');"
      set << "sel_major.value = '#{major.id}';"
      set << "sel_major.disabled = false;"
      set << "document.getElementById('select_department_id').value = '#{major.department_id}';"
      html.sub!("<major_options>",sel_major_options).sub!("<set_major_id>",set)
    else
      html.sub!("<major_options>",'').sub!("<set_major_id>",'')
    end

    if class_id
      info_class = InfoClass.find(class_id)
      sel_class_options = info_class.major.info_classes.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
      set = "var sel_class = document.getElementById('select_class_id');"
      set << "sel_class.value = '#{info_class.id}';"
      set << "sel_class.disabled = false;"
      set << "document.getElementById('select_major_id').value = '#{info_class.major_id}';"
      html.sub!("<class_options>",sel_class_options).sub!("<set_class_id>",set)
    else
      html.sub!("<class_options>",'').sub!("<set_class_id>",'')
    end
    return html
  end
end
