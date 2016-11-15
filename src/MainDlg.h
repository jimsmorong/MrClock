
// MainDlg.h : ͷ�ļ�
//

#pragma once
#include "afxwin.h"
#include <ResizableLib/ResizableDialog.h>
#include <mrui/DigitNumWnd.h>


// CMainDlg �Ի���
class CMainDlg : public CResizableDialog
{
// ����
public:
    CMainDlg(CWnd* pParent = NULL);	// ��׼���캯��
    virtual ~CMainDlg();
// �Ի�������
    enum { IDD = IDD_MAIN_DIALOG };

    protected:
    virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��


// ʵ��
protected:
    HICON m_hIcon;
    // ���ɵ���Ϣӳ�亯��
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
