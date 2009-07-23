# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def app_name
    return "迎新系统"
  end

  #select options for index searching
  def list_departments_for_search
    @options = [["所有",""]]
    Department.find_by_sql("select id,name from departments").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end

  #fuzzy time
  def fuzzy_time(time)
    time.strftime("%Y") + " 年 " + time.strftime("%m").to_i.to_s + " 月 " + time.strftime("%d").to_i.to_s + " 日 "
  end

  #fuzzy gender
  def fuzzy_gender(gender)
    gender.to_s == "m" ? "男" : "女"
  end

  def proc_format(pass)
    pass.to_s == "true" ? "完成" : "未完成"
  end

  def current_admin?
    name = "admin"
    return true if @current_user.roles.find_by_name(name)
  end
  
  #ajax pagination for will_paginate plugin
  def will_paginate_remote(paginator, options={})
    update = options.delete(:update)
    url = options.delete(:url)
    str = will_paginate(paginator, options)
    if str != nil
      str.gsub(/href="(.*?)"/) do
        "href=\"#\" onclick=\"new Ajax.Updater('" + update + "', '" + (url ? url + $1.sub(/[^\?]*/, '') : $1) +
          "', {asynchronous:true, evalScripts:true, method:'get',}); return false;\""
      end
    end
  end

  def select_user(name="user_id")
    options = Department.all.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
      <p>
        <label for="select_department_id">部门</label>
        <select id="select_department_id" class="required">
          <option value='' >选择系统部...</option>
          <options>
        </select>
      </p>
      <p>
        <label for="select_user_id">教职工</label>
        <select id="select_user_id" disabled="disabled" name="<name>" class="required">
          <option value='' >选择管理员...</option>
        </select>
      </p>
      <script>
        jQuery("#select_department_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_user_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "选择教职工...";
          select.options.add(option);
          if(v){
            jQuery.ajax({
              url: "/departments/users_to_json",
              data: {id: v},
              type: "POST",
              success: function(data){
                var users = Ext.util.JSON.decode(data); 
                for(var i=0, l=users.length; i<l; i++){
                  var option = document.createElement("option");
                  var u = users[i];
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

  def select_major(name="major_id")
    options = Department.find(:all, :conditions => ["de_type =?", true]).collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
      <p>
        <label for="select_department_id">院系</label>
        <select id="select_department_id" class="required">
          <option value='' >请选择院系...</option>
          <options>
        </select>
      </p>
      <p>
        <label for="select_major_id">专业</label>
        <select id="select_major_id" disabled="disabled" name="<name>" class="required">
          <option value='' >请选择专业...</option>
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
          option.text = "请选择专业...";
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
        })
      </script>
    }
    html.sub!("<options>",options).sub!("<name>",name)
  end

  #ajax selection for 3 lists  for index searching
  def index_select_class
    options = Department.find(:all, :conditions => ["de_type=?",true]).collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
        <label for="select_department_id">院系</label>
        <select id="select_department_id" name="department_id" style="margin:0px;padding:0px;float:none;">
          <option value='' >请选择院系...</option>
          <options>
        </select>
        <label for="select_major_id">专业</label>
        <select id="select_major_id" disabled="disabled" name="major_id" style="margin:0px;padding:0px;float:none;">
          <option value='' >请选择专业...</option>
        </select>
        <label for="select_class_id">班级</label>
        <select id="select_class_id" disabled="disabled" name="class_id" style="margin:0px;padding:0px;float:none;">
          <option value='' >请选择班级...</option>
        </select>

      <script>
        jQuery("#select_department_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_major_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "请选择专业...";
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
        })
      </script>
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

  def select_nation
    %q{
    <select name="search_nation" id="search_nation">
 <option selected="selected" value="">请选择民族...</option>
 <option value="汉族">汉族                            </option>
 <option value="蒙古族">蒙古族                           </option>
 <option value="彝族">彝族                            </option>
 <option value="侗族">侗族                            </option>
 <option value="哈萨克族">哈萨克族                          </option>
 <option value="畲族">畲族                            </option>
 <option value="纳西族">纳西族                           </option>
 <option value="仫佬族">仫佬族                           </option>
 <option value="仡佬族">仡佬族                           </option>
 <option value="怒族">怒族                            </option>
 <option value="保安族">保安族                           </option>
 <option value="鄂伦春族">鄂伦春族                          </option>
 <option value="回族">回族                            </option>
 <option value="壮族">壮族                            </option>
 <option value="瑶族">瑶族                            </option>
 <option value="傣族">傣族                            </option>
 <option value="高山族">高山族                           </option>
 <option value="景颇族">景颇族                           </option>
 <option value="羌族">羌族                            </option>
 <option value="锡伯族">锡伯族                           </option>
 <option value="乌孜别克族">乌孜别克族                         </option>
 <option value="裕固族">裕固族                           </option>
 <option value="赫哲族">赫哲族                           </option>
 <option value="藏族">藏族                            </option>
 <option value="布依族">布依族                           </option>
 <option value="白族">白族                            </option>
 <option value="黎族">黎族                            </option>
 <option value="拉祜族">拉祜族                           </option>
 <option value="柯尔克孜族">柯尔克孜族                         </option>
 <option value="布朗族">布朗族                           </option>
 <option value="阿昌族">阿昌族                           </option>
 <option value="俄罗斯族">俄罗斯族                          </option>
 <option value="京族">京族                            </option>
 <option value="门巴族">门巴族                           </option>
 <option value="维吾尔族">维吾尔族                          </option>
 <option value="朝鲜族">朝鲜族                           </option>
 <option value="土家族">土家族                           </option>
 <option value="傈僳族">傈僳族                           </option>
 <option value="水族">水族                            </option>
 <option value="土族">土族                            </option>
 <option value="撒拉族">撒拉族                           </option>
 <option value="普米族">普米族                           </option>
 <option value="鄂温克族">鄂温克族                          </option>
 <option value="塔塔尔族">塔塔尔族                          </option>
 <option value="珞巴族">珞巴族                           </option>
 <option value="苗族">苗族                            </option>
 <option value="满族">满族                            </option>
 <option value="哈尼族">哈尼族                           </option>
 <option value="佤族">佤族                            </option>
 <option value="东乡族">东乡族                           </option>
 <option value="达斡尔族">达斡尔族                          </option>
 <option value="毛南族">毛南族                           </option>
 <option value="塔吉克族">塔吉克族                          </option>
 <option value="德昂族">德昂族                           </option>
 <option value="独龙族">独龙族                           </option>
 <option value="基诺族">基诺族                           </option>
</select>}
  end

  def page_info
    render :partial => "/share/page_info"
  end
end
