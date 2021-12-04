//
//  ViewController.m
//  OpenGLDemo
//
//  Created by wangqiang on 2021/12/4.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
@interface ViewController () {
    EAGLContext *context;
    GLKBaseEffect *cEffect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConfig];
    [self setupVertexData];
    [self setupTexture];
}
- (void)setupTexture {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kunkun" ofType:@"jpg"];
    // 2.纹理参数
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@1, GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    cEffect = [[GLKBaseEffect alloc] init];
    cEffect.texture2d0.enabled = GL_TRUE;
    cEffect.texture2d0.name = textureInfo.name;
    
    
}
- (void)setupVertexData{
    GLfloat vertexData[] = {
      0.5, -0.5, 0.0f,      1.0f, 0.0f,  //右下
      0.5, 0.5, 0.0f,       1.0f, 1.0f, //右上
      -0.5, 0.5, 0.0f,      0.0f, 1.0f,
      
      0.5,-0.5,0.0f,         1.0f,0.0f,
      -0.5, 0.5, 0.0f,       0.0f, 1.0f,
       -0.5, -0.5,1.0f,      0.0f,0.0f,
    };
    
    // 顶点缓冲区 存在 GPU里面
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    
    //绑定顶点缓冲区
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    //3.打开读取通道.
    /*
     (1)在iOS中, 默认情况下，出于性能考虑，所有顶点着色器的属性（Attribute）变量都是关闭的.
     意味着,顶点数据在着色器端(服务端)是不可用的. 即使你已经使用glBufferData方法,将顶点数据从内存拷贝到顶点缓存区中(GPU显存中).
     所以, 必须由glEnableVertexAttribArray 方法打开通道.指定访问属性.才能让顶点着色器能够访问到从CPU复制到GPU的数据.
     注意: 数据在GPU端是否可见，即，着色器能否读取到数据，由是否启用了对应的属性决定，这就是glEnableVertexAttribArray的功能，允许顶点着色器读取GPU（服务器端）数据。
   
    (2)方法简介
    glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)
   
    功能: 上传顶点数据到显存的方法（设置合适的方式从buffer里面读取数据）
    参数列表:
        index,指定要修改的顶点属性的索引值,例如
        size, 每次读取数量。（如position是由3个（x,y,z）组成，而颜色是4个（r,g,b,a）,纹理则是2个.）
        type,指定数组中每个组件的数据类型。可用的符号常量有GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT,GL_UNSIGNED_SHORT, GL_FIXED, 和 GL_FLOAT，初始值为GL_FLOAT。
        normalized,指定当被访问时，固定点数据值是否应该被归一化（GL_TRUE）或者直接转换为固定点值（GL_FALSE）
        stride,指定连续顶点属性之间的偏移量。如果为0，那么顶点属性会被理解为：它们是紧密排列在一起的。初始值为0
        ptr指定一个指针，指向数组中第一个顶点属性的第一个组件。初始值为0
     */
    
    //顶点坐标数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 3);
}

- (void)setupConfig{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        NSLog(@"Create EAGLContext failed");
    }
    
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = (GLKView *)self.view;
    
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
    // 设置背景色
    glClearColor(1, 0, 0, 1);
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    
   // 2. 准备绘制
    [cEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
