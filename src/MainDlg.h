
// MainDlg.h : 头文件
//

#pragma once
#include "afxwin.h"
#include <ResizableLib/ResizableDialog.h>
#include <mrui/DigitNumWnd.h>


// CMainDlg 对话框
class CMainDlg : public CResizableDialog
{
// 构造
public:
    CMainDlg(CWnd* pParent = NULL);	// 标准构造函数
    virtual ~CMainDlg();
// 对话框数据
    enum { IDD = IDD_MAIN_DIALOG };

    protected:
    virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
    HICON m_hIcon;
    // 生成的消息映射函数
    virtual BOOL OnInitDialog();
    afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
    afx_msg void OnPaint();
    afx_msg HCURSOR OnQueryDragIcon();


    DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnClose();
    afx_msg void OnTimer(UINT_PTR nIDEvent);
    afx_msg void OnBnClickedOk();
    afx_msg void OnBnClickedCancel();
    virtual BOOL PreTranslateMessage(MSG* pMsg);
    afx_msg void OnBnClickedButton1();

    bool m_bShowDigitWnd;
    bool m_bLockThis;
    afx_msg void OnBnClickedButton2();

    DigitNumWnd m_digitWnd;
    afx_msg void OnBnClickedButton3();
    CRichEditCtrl m_edtText;

    afx_msg LRESULT OnTrayNotify(WPARAM /*wp*/, LPARAM lp);
    NOTIFYICONDATA	m_nid;
};
