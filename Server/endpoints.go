package main

import (
	"net/http"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
)

func sendLib(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/lib", filepath.Join(pkg, ".lib"))
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusOK, "Error occured\nStatic library not found")
	}
	context.File(pkgPath)
}

func sendDll(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/dll", filepath.Join(pkg, ".dll"))
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusOK, "Error occured\nDynamic library not found")
	}
	context.File(pkgPath)
}

func sendSrc(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/", pkg)
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil || fileInfo.IsDir() != true {
		context.String(http.StatusOK, "Error occured\nDynamic library not found")
	}
	context.File(pkgPath)
}

func upload(context *gin.Context) {

}
