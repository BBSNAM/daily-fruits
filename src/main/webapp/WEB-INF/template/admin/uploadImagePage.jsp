<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>新增</title>
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <!-- <link rel="stylesheet" href="./css/theme5.css"> -->
    <script src="../css/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <style>
        html {
            height: 100%;
        }

        .layui-form-pane .layui-form-text .layui-textarea {
            min-height: 80px;
            max-height: 80px;
        }

        .div_show {
            transform: translate(-2000px);
            transition: all 0.8s;
        }

        .div_hide {
            transform: translate(2000px);
            transition: all 1.5s;
        }

        .photo-viewer {
            margin: 50px 0;
            text-align: center;
        }

        .img-reveal {
            display: inline-block;
            margin: 0px 8px;
        }

        .layui-btn {
            height: 34px;
            line-height: 34px;
        }
        .layui-form-select dl {
            max-height: 195px;
        }
    </style>
</head>
<body style="height: 100%;box-sizing: border-box">
<!-- 保存本次上传的类型 -->
<input type="hidden" value="${type}" name="type">
<div class="layui-upload" style="padding: 15px;">
    <button type="button" class="layui-btn layui-btn-normal" id="selectImgBtn">选择要上传的文件</button>
    <div class="layui-upload-list">
        <table class="layui-table">
            <thead>
            <tr><th>文件名</th>
                <th>大小</th>
                <th>状态</th>
                <th>操作</th>
            </tr></thead>
            <tbody id="showFileTable"></tbody>
        </table>
    </div>
    <button type="button" class="layui-btn" id="startUpload">开始上传</button>
</div>
<script>
    layui.use(['form', 'upload', 'table'], function () {

        var upload = layui.upload;

        //多文件列表示例
        var showFileTable = $('#showFileTable');

        var type = $("input[name='type']").val();

        var uploadListIns = upload.render({
            elem: '#selectImgBtn'
            ,url: 'toUploadServer.do?type='+type //改成您自己的上传接口
            ,accept: 'file'
            ,multiple: true
            ,auto: false
            // ,size: 10240
            ,bindAction: '#startUpload' //绑定开始上传按钮
            ,choose: function(obj){
                var files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列
                //读取本地文件
                obj.preview(function(index, file, result){
                    var tr = $(['<tr id="upload-'+ index +'">'
                        ,'<td>'+ file.name +'</td>'
                        ,'<td>'+ (file.size/1024).toFixed(1) +'kb</td>'
                        ,'<td>等待上传</td>'
                        ,'<td>'
                        ,'<button class="layui-btn layui-btn-xs demo-reload layui-hide">重传</button>'
                        ,'<button class="layui-btn layui-btn-xs layui-btn-danger demo-delete">删除</button>'
                        ,'</td>'
                        ,'</tr>'].join(''));

                    //单个重传
                    tr.find('.demo-reload').on('click', function(){
                        obj.upload(index, file);
                    });

                    //删除
                    tr.find('.demo-delete').on('click', function(){
                        delete files[index]; //删除对应的文件
                        tr.remove();
                        uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                    });

                    showFileTable.append(tr);
                });
            }
            ,before: function(obj) {
                layer.load();
            }
            ,done: function(res, index, upload){
                console.log(res);
                if(res.code == "200"){ //上传成功
                    var tr = showFileTable.find('tr#upload-'+ index)
                        ,tds = tr.children();
                    tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
                    tds.eq(3).html(''); //清空操作
                    layer.closeAll('loading');
                    return delete this.files[index]; //删除文件队列已经上传成功的文件
                }
                this.error(index, upload);
            }
            ,error: function(index, upload){
                var tr = showFileTable.find('tr#upload-'+ index)
                    ,tds = tr.children();
                tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
                tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
                layer.closeAll('loading');
            }
        });
    });
</script>
</body>
</html>