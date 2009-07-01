#ifndef _GLES_TO_WGL_H_
#define _GLES_TO_WGL_H_

#ifndef IPHONE

extern void LinkOES2EXT();

#define glClearDepthf glClearDepth
#define glFrustumf glFrustum
#define glOrthof glOrtho


//GL_EXT_framebuffer_object
#define GL_RENDERBUFFER_BINDING_OES GL_RENDERBUFFER_BINDING_EXT
#define GL_FRAMEBUFFER_BINDING_OES	GL_FRAMEBUFFER_BINDING_EXT
#define GL_FRAMEBUFFER_OES GL_FRAMEBUFFER_EXT
#define GL_RENDERBUFFER_OES GL_RENDERBUFFER_EXT
#define GL_DEPTH_COMPONENT24_OES GL_DEPTH_COMPONENT24
#define GL_DEPTH_ATTACHMENT_OES	GL_DEPTH_ATTACHMENT_EXT
#define GL_COLOR_ATTACHMENT0_OES GL_COLOR_ATTACHMENT0_EXT
#define GL_FRAMEBUFFER_COMPLETE_OES	GL_FRAMEBUFFER_COMPLETE_EXT
#define GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_OES GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT

//methods
extern PFNGLGENFRAMEBUFFERSEXTPROC glGenFramebuffersOES;
extern PFNGLBINDFRAMEBUFFEREXTPROC glBindFramebufferOES;
extern PFNGLGENRENDERBUFFERSEXTPROC glGenRenderbuffersOES;
extern PFNGLBINDRENDERBUFFEREXTPROC glBindRenderbufferOES;
extern PFNGLRENDERBUFFERSTORAGEEXTPROC glRenderbufferStorageOES;
extern PFNGLFRAMEBUFFERRENDERBUFFEREXTPROC glFramebufferRenderbufferOES;
extern PFNGLFRAMEBUFFERTEXTURE2DEXTPROC glFramebufferTexture2DOES;
extern PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC glGetFramebufferAttachmentParameterivOES;
extern PFNGLCHECKFRAMEBUFFERSTATUSEXTPROC glCheckFramebufferStatusOES;
extern PFNGLDELETEFRAMEBUFFERSEXTPROC glDeleteFramebuffersOES;
extern PFNGLDELETERENDERBUFFERSEXTPROC glDeleteRenderbuffersOES;

extern PFNGLACTIVETEXTUREARBPROC glActiveTexture;
extern PFNGLCLIENTACTIVETEXTUREARBPROC glClientActiveTexture;
extern PFNGLBLENDCOLORPROC glBlendColor;

#endif//!IPHONE

#endif //_GLES_TO_WGL_H_