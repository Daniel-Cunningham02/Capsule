package main

import (
	"net/http"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
)

func sendLib(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/lib/", (pkg + ".lib"))
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusBadRequest, "Error occured\nStatic library not found\n")
		return
	}
	context.FileAttachment(pkgPath, (pkg + ".lib"))
	context.Status(http.StatusAccepted)
}

func sendDll(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/dll/", (pkg + ".dll"))
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusOK, "Error occured\nDynamic library not found\n")
		return
	}
	context.FileAttachment(pkgPath, (pkg + ".dll"))
	context.Status(http.StatusAccepted)
}

func sendSrc(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/", pkg)
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil || fileInfo.IsDir() != true {
		context.String(http.StatusOK, "Error occured\nPackage not found\n")
		return
	}
	context.File(pkgPath)
}

func upload(context *gin.Context) {
	pkgName := context.Param("package")
	context.String(http.StatusAccepted, pkgName)
}
