<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<html>
<head>
    <title>员工列表</title>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add">新增</button>
            <button class="btn btn-danger" id="emp_delete_all">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6" id="page_info_area"></div>
        <div class="col-md-6" id="page_info_nav"></div>
    </div>
</div>
<div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group help-css" id="empName_div">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="员工姓名">
                            <label class="control-label help-text" id="empName_validate_info"></label>
                        </div>
                    </div>
                    <div class="form-group help-css" id="empEmail_div">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="empEmail_add_input" placeholder="email@email.com">
                            <label class="control-label help-text" id="empEmail_validate_info"></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_male" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_female" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-3">
                            <select class="form-control" name="dId" id="dept_add_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="emp_update_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group help-css" id="empName_update_div">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_update_input" placeholder="员工姓名">
                            <label class="control-label help-text" id="empName_update_info"></label>
                        </div>
                    </div>
                    <div class="form-group help-css">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="email_update"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-3">
                            <select class="form-control" name="dId" id="dept_update_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
            </div>
        </div>
    </div>
</div>
<script src="${APP_PATH}/static/jQuery/jquery-3.4.1.min.js"></script>
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">

    var totalRecords, currentPage;

    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                // console.log(result);
                // 解析并显示员工数据
                build_emps_table(result);
                // 解析并显示分页信息
                build_page_info(result);
                // 解析并显示分页条
                build_page_nav(result);
            }
        });
    }

    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender === 'M' ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            editBtn.attr("edit_id", item.empId);
            var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            deleteBtn.attr("delete_id", item.empId);
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(deleteBtn);
            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }

    function build_page_info(result) {
        $("#page_info_area").empty();
        var page_num = result.extend.pageInfo.pageNum;
        var pages = result.extend.pageInfo.pages;
        var total_num = result.extend.pageInfo.total;
        currentPage = page_num;
        totalRecords = total_num;
        $("#page_info_area").append("当前正在第" + page_num + "页, 总共" + pages + "页, 总共" + total_num + "条记录");
    }

    function build_page_nav(result) {
        $("#page_info_nav").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        firstPageLi.click(function () {
            to_page(1);
        });
        var prePageLi = $("<li></li>").append($("<a></a>")
            .append($("<span></span>").append("&laquo;").attr("aria-hidden", "true"))
            .attr("href", "#").attr("aria-label", "Previous"));
        prePageLi.click(function () {
            to_page(result.extend.pageInfo.pageNum - 1);
        });
        if (!result.extend.pageInfo.hasPreviousPage) {
            firstPageLi.addClass("disabled");
            ul.append(firstPageLi);
        } else {
            ul.append(firstPageLi);
            ul.append(prePageLi);
        }

        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item).attr("href", "#"));
            if (result.extend.pageInfo.pageNum === item) {
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });

        var nextPageLi = $("<li></li>").append($("<a></a>")
            .append($("<span></span>").append("&raquo;").attr("aria-hidden", "true"))
            .attr("href", "#").attr("aria-label", "Next"));
        nextPageLi.click(function () {
            to_page(result.extend.pageInfo.pageNum + 1);
        });
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        lastPageLi.click(function () {
            to_page(result.extend.pageInfo.pages);
        });
        if (!result.extend.pageInfo.hasNextPage) {
            lastPageLi.addClass("disabled");
        } else {
            ul.append(nextPageLi);
        }
        ul.append(lastPageLi);

        var navEle = $("<nav></nav>").append(ul).attr("aria-label", "Page navigation");
        $("#page_info_nav").append(navEle);
    }

    function clear_form(ele) {
        $(ele)[0].reset();
        $(ele).find(".help-css").removeClass("has-success has-error");
        $(ele).find(".help-text").html("");
    }

    $("#emp_add").click(function () {
        // 清除表单数据
        clear_form("#emp_add_modal form");
        // 发送ajax请求, 获得部门信息, 显示在下拉列表中
        getDepts("#dept_add_select");
        // 弹出模态框
        $("#emp_add_modal").modal({
            backdrop: "static"
        });
    });

    // 查出部门信息
    function getDepts(ele) {
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success: function (result) {
                $.each(result.extend.depts, function () {
                    var options = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    $(ele).append(options);
                })
            }
        });
    }

    function validate_add_form() {
        // 1.校验用户名
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,8})/;
        if (!regName.test(empName)) {
            show_validate_info("#empName_div", "#empName_validate_info", "error", "用户名须为2-8位中文或者3-16位英文和数字的组合！");
            return false;
        } else {
            show_validate_info("#empName_div", "#empName_validate_info", "success", "");
        }
        // 2.校验邮箱
        var email = $("#empEmail_add_input").val();
        var regEmail = /^([a-zA-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            show_validate_info("#empEmail_div", "#empEmail_validate_info", "error", "邮箱格式不正确！");
            return false;
        } else {
            show_validate_info("#empEmail_div", "#empEmail_validate_info", "success", "");
        }
        return true;
    }

    function show_validate_info(ele1, ele2, status, msg) {
        $(ele1).removeClass("has-success has-error");
        $(ele2).html("");
        if (status === "success") {
            $(ele1).addClass(" has-success");
            $(ele2).html(msg);
        } else if (status === "error") {
            $(ele1).addClass(" has-error");
            $(ele2).html(msg);
        }
    }

    $("#empName_add_input").change(function () {
        var empName = this.value;
        $.ajax({
            url: "${APP_PATH}/checkEmpName",
            data: "empName=" + empName,
            type: "POST",
            success: function (result) {
                if (result.code === 100) {
                    show_validate_info("#empName_div", "#empName_validate_info", "success", "用户名可用！");
                    $("#emp_save_btn").removeAttr("disabled");
                } else {
                    show_validate_info("#empName_div", "#empName_validate_info", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("disabled", "disabled");
                }
            }
        });
    });

    $("#empEmail_add_input").change(function () {
        var email = this.value;
        $.ajax({
            url: "${APP_PATH}/checkEmail",
            data: "email=" + email,
            type: "POST",
            success: function (result) {
                if (result.code === 100) {
                    show_validate_info("#empEmail_div", "#empEmail_validate_info", "success", "该邮箱可用！");
                    $("#emp_save_btn").removeAttr("disabled");
                } else {
                    show_validate_info("#empEmail_div", "#empEmail_validate_info", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("disabled", "disabled");
                }
            }
        });
    });

    $("#emp_save_btn").click(function () {
        // 1.先对要提交的数据进行校验
        if (validate_add_form()) {
            $.ajax({
                url: "${APP_PATH}/emp",
                type: "POST",
                data: $("#emp_add_modal form").serialize(),
                success: function (result) {
                    if (result.code === 100) {
                        // 关闭模态框
                        $("#emp_add_modal").modal('hide');
                        // 跳转到最后一页
                        to_page(totalRecords)
                    } else {
                        console.log(result);
                        if (undefined !== result.extend.errorFields.email) {
                            show_validate_info("#empEmail_div", "#empEmail_validate_info", "error", result.extend.errorFields.email);
                        }
                        if (undefined !== result.extend.errorFields.empName) {
                            show_validate_info("#empName_div", "#empName_validate_info", "error", result.extend.errorFields.empName);
                        }
                    }
                }
            });
        }
    });

    $(document).on("click", ".edit_btn", function () {

        // 1.查出部门信息并显示在下拉列表
        getDepts("#dept_update_select");
        // 2.查出员工信息并显示
        getEmp($(this).attr("edit_id"));
        $("#emp_update_btn").attr("edit_id", $(this).attr("edit_id"));
        $("#emp_update_modal").modal({
            backdrop: "static"
        });
    });

    function getEmp(id) {
        $.ajax({
            url: "${APP_PATH}/emp/" + id,
            type: "GET",
            success: function (result) {
                console.log(result);
                var empData = result.extend.emp;
                $("#empName_update_input").val(empData.empName);
                $("#email_update").text(empData.email);
                $("#emp_update_modal input[name=gender]").val([empData.gender]);
                $("#emp_update_modal select").val([empData.dId]);
            }
        });
    }

    $("#emp_update_btn").click(function () {
        // 1.校验用户名格式
        var empName = $("#empName_update_input").val();
        var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,8})/;
        if (!regName.test(empName)) {
            show_validate_info("#empName_update_div", "#empName_update_info", "error", "用户名须为2-8位中文或者3-16位英文和数字的组合！");
            return false;
        } else {
            show_validate_info("#empName_update_div", "#empName_update_info", "success", "");
        }
        // 发送ajax请求更新用户
        $.ajax({
            url: "${APP_PATH}/emp/" + $(this).attr("edit_id"),
            type: "PUT",
            data: $("#emp_update_modal form").serialize(),
            success: function(result) {
                // alert(result.msg);
                // 1.关闭模态框
                $("#emp_update_modal").modal("hide");
                // // 2.回到本页面
                // alert(currentPage);
                to_page(currentPage);
            }
        });
    });

    $(document).on("click", ".delete_btn", function () {
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("delete_id");
        if (confirm("确认删除【" + empName + "】吗？")) {
            $.ajax({
                url: "${APP_PATH}/emp/" + empId,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }
    });

    $("#check_all").click(function () {
        $(".check_item").prop("checked",  $(this).prop("checked"));
    });

    $(document).on("click", ".check_item", function () {
        var flag = $(".check_item:checked").length === $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    $("#emp_delete_all").click(function () {
        var empNames = "";
        var del_str_id = "";
        $.each($(".check_item:checked"), function () {
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            del_str_id += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        empNames = empNames.substring(0, empNames.length - 1);
        del_str_id = del_str_id.substring(0, del_str_id.length - 1);
        if (confirm("确认删除【" + empNames + "】吗？")) {
            // 发送ajax请求删除多条员工记录
            $.ajax({
                url: "${APP_PATH}/emp/" + del_str_id,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }
    });

</script>
</body>
</html>