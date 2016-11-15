
// MainDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "TheApp.h"
#include "MainDlg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif

#define  IDC_TRAYICON      2012

#define  IDT_CHECKTIME    1093
#define  IDT_CHECKCLOSE   1094

#define  NUM_CHECK_DISTIME        1000
#define  TIMEDIS_IDT_CHECKCLOSE   1000

#define UM_TRAYNOTIFY	(WM_USER + 1)

// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
    CAboutDlg();

    // 对话框数据
    enum { IDD = IDD_ABOUTBOX };

protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

    // 实现
protected:
    DECLARE_MESSAGE_MAP()
public:
    virtual BOOL OnInitDialog();
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CMainDlg 对话框




CMainDlg::CMainDlg(CWnd* pParent /*=NULL*/)
    : CResizableDialog(CMainDlg::IDD, pParent)
{
    m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    // Initialize NOTIFYICONDATA
    memset(&m_nid, 0 , sizeof(m_nid));
    m_nid.cbSize = sizeof(m_nid);
    m_nid.uFlags = NIF_ICON | NIF_TIP | NIF_MESSAGE;
    m_bShowDigitWnd = false;
}

CMainDlg::~CMainDlg()
{
        m_nid.hIcon = NULL;
        Shell_NotifyIcon (NIM_DELETE, &m_nid);
}

void CMainDlg::DoDataExchange(CDataExchange* pDX)
{
    CResizableDialog::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_EDIT1, m_edtText);
}

BEGIN_MESSAGE_MAP(CMainDlg, CResizableDialog)
    ON_WM_SYSCOMMAND()
    ON_WM_PAINT()
    ON_WM_QUERYDRAGICON()
    //ON_COMMAND(ID_TRAYICON_CLOSE, OnTrayiconClose)
    //}}AFX_MSG_MAP
    ON_WM_CLOSE()
    ON_WM_TIMER()
    ON_BN_CLICKED(IDOK, &CMainDlg::OnBnClickedOk)
    ON_BN_CLICKED(IDCANCEL, &CMainDlg::OnBnClickedCancel)
    ON_BN_CLICKED(IDC_BUTTON1, &CMainDlg::OnBnClickedButton1)
    ON_BN_CLICKED(IDC_BUTTON2, &CMainDlg::OnBnClickedButton2)
    ON_BN_CLICKED(IDC_BUTTON3, &CMainDlg::OnBnClickedButton3)
    ON_MESSAGE(UM_TRAYNOTIFY, OnTrayNotify)
END_MESSAGE_MAP()




BOOL CMainDlg::OnInitDialog()
{
    CResizableDialog::OnInitDialog();

    // 将“关于...”菜单项添加到系统菜单中。

    // IDM_ABOUTBOX 必须在系统命令范围内。
    ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
    ASSERT(IDM_ABOUTBOX < 0xF000);

    CMenu* pSysMenu = GetSystemMenu(FALSE);
    if (pSysMenu != NULL)
    {
        BOOL bNameValid;
        CString strAboutMenu;
        bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
        ASSERT(bNameValid);
        if (!strAboutMenu.IsEmpty())
        {
            pSysMenu->AppendMenu(MF_SEPARATOR);
            pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
        }
    }

    // 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
    //  执行此操作
    SetIcon(m_hIcon, TRUE);         // 设置大图标
    SetIcon(m_hIcon, FALSE);        // 设置小图标

    // TODO: 在此添加额外的初始化代码
    AddAnchor(IDOK, BOTTOM_RIGHT);
    AddAnchor(IDCANCEL, BOTTOM_RIGHT);

    AddAnchor(IDC_STATIC_TIME, TOP_LEFT);
    AddAnchor(IDC_EDIT1, TOP_LEFT, BOTTOM_RIGHT);

    AddAnchor(IDC_STATIC_PASSWORD, BOTTOM_RIGHT);
    AddAnchor(IDC_EDIT_PASSWORKD, BOTTOM_RIGHT);
    AddAnchor(IDC_BUTTON1, BOTTOM_RIGHT);

    //AddAnchor(IDC_BUTTON1, BOTTOM_RIGHT);

    AddAnchor(IDC_BUTTON2, TOP_RIGHT);
    AddAnchor(IDC_BUTTON3, BOTTOM_RIGHT);

    m_bLockThis = true; 

    SetTimer(IDT_CHECKTIME,100,NULL);

    CButton* btnUnLock = (CButton*)GetDlgItem(IDC_BUTTON1);
    btnUnLock->ShowWindow(SW_SHOW); 

    m_nid.hWnd = GetSafeHwnd ();
    m_nid.uCallbackMessage = UM_TRAYNOTIFY;
    m_nid.hIcon = m_hIcon;
    
    CString strToolTip = _T("MrClock");
    _tcsncpy_s (m_nid.szTip, strToolTip, strToolTip.GetLength ());
    
    Shell_NotifyIcon (NIM_ADD, &m_nid);

    return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CMainDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
    if ((nID & 0xFFF0) == IDM_ABOUTBOX)
    {
        CAboutDlg dlgAbout;
        dlgAbout.DoModal();
    }
    else if(nID == SC_MINIMIZE)
    {
        ShowWindow(SW_HIDE);
    }
    else
    {
        CDialog::OnSysCommand(nID, lParam);
    }
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CMainDlg::OnPaint()
{
    if (IsIconic())
    {
        CPaintDC dc(this); // 用于绘制的设备上下文

        SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

        // 使图标在工作区矩形中居中
        int cxIcon = GetSystemMetrics(SM_CXICON);
        int cyIcon = GetSystemMetrics(SM_CYICON);
        CRect rect;
        GetClientRect(&rect);
        int x = (rect.Width() - cxIcon + 1) / 2;
        int y = (rect.Height() - cyIcon + 1) / 2;

        // 绘制图标
        dc.DrawIcon(x, y, m_hIcon);
    }
    else
    {
        CRect   rect;
        CPaintDC   dc(this);
        GetClientRect(rect);
        dc.FillSolidRect(rect,RGB(0,0,0));   //设置为绿色背景

        CDialog::OnPaint();
    }
}

//当用户拖动最小化窗口时系统调用此函数取得光标显示。
HCURSOR CMainDlg::OnQueryDragIcon()
{
    return static_cast<HCURSOR>(m_hIcon);
}

void CMainDlg::OnClose()
{
    ShowWindow(SW_HIDE);
    //CDialog::OnClose();
}

void CMainDlg::OnTimer(UINT_PTR nIDEvent)
{
    if(nIDEvent == IDT_CHECKTIME)
    {
        KillTimer(IDT_CHECKTIME);

        CStatic* pTime = (CStatic*)GetDlgItem(IDC_STATIC_TIME);
        static time_t rawtime;
        time(&rawtime); 
        static struct tm timeinfo;
        localtime_s(&timeinfo,&rawtime );
        static TCHAR szTime[260];
        static int nTimeDis = 1000;


        if (   (timeinfo.tm_min == 59) 
            || (timeinfo.tm_min == 58)
            || (timeinfo.tm_min == 57)
            || (timeinfo.tm_min == 00)
            || (timeinfo.tm_min == 01)
            || (timeinfo.tm_min == 02)
            || (timeinfo.tm_min == 27)
            || (timeinfo.tm_min == 28)
            || (timeinfo.tm_min == 29)
            || (timeinfo.tm_min == 30)
            || (timeinfo.tm_min == 31)
            || (timeinfo.tm_min == 32)
            )
        {
            if (m_bLockThis)
            {
                ::SetWindowPos(m_hWnd,HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);
                ShowWindow(SW_MAXIMIZE);
                SetForegroundWindow();
                nTimeDis = 500;

                //::SetWindowPos(m_digitWnd.m_hWnd,HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);
                if (m_bShowDigitWnd)
                {
                    if (m_digitWnd.GetAlwaysTop())
                    {
                        m_digitWnd.SetAlwaysTop(false);
                    }
                }

            }
            else
            {
                nTimeDis = NUM_CHECK_DISTIME;
                if (m_bShowDigitWnd)
                {
                    m_digitWnd.SetAlwaysTop(true);
                }
                
            }

            _stprintf_s(szTime,_T("现在时间:%02d:%02d:%02d"),timeinfo.tm_hour,timeinfo.tm_min,timeinfo.tm_sec);
            pTime->SetWindowText(szTime);
            SetTimer(IDT_CHECKTIME,nTimeDis,NULL);
        }
        else
        {
            nTimeDis = NUM_CHECK_DISTIME;
            m_bLockThis = true;
            _stprintf_s(szTime,_T("现在时间:%02d:%02d:%02d"),timeinfo.tm_hour,timeinfo.tm_min,timeinfo.tm_sec);
            pTime->SetWindowText(szTime);
            SetTimer(IDT_CHECKTIME,nTimeDis,NULL);
        }
    }
    CDialog::OnTimer(nIDEvent);
}


void CMainDlg::OnBnClickedOk()
{
    ShowWindow(SW_HIDE);
    //CDialog::OnOK();
}


void CMainDlg::OnBnClickedCancel()
{
    ShowWindow(SW_HIDE);
}


BOOL CMainDlg::PreTranslateMessage(MSG* pMsg)
{
    // TODO: Add your specialized code here and/or call the base class
    if (pMsg->message == WM_KEYDOWN)
    {
        if(pMsg->message==WM_KEYDOWN && pMsg->wParam==VK_RETURN)
        {  
            UINT nID = GetFocus()->GetDlgCtrlID();  
            if (nID != IDC_EDIT1)
            {
                return TRUE;
            }
        }

    }
    return CResizableDialog::PreTranslateMessage(pMsg);
}


void CMainDlg::OnBnClickedButton1()
{
    CStatic* pStcPwd = (CStatic*)GetDlgItem(IDC_STATIC_PASSWORD);
    CEdit* pEdtPwd = (CEdit*)GetDlgItem(IDC_EDIT_PASSWORKD);
    CButton* pBtnUnLock = (CButton*)GetDlgItem(IDC_BUTTON1);
    if (!pStcPwd->IsWindowVisible())
    {
        pStcPwd->ShowWindow(SW_SHOW);
        pEdtPwd->ShowWindow(SW_SHOW);
        pBtnUnLock->SetWindowText(_T("确定解锁"));
    }
    else
    {
        pStcPwd->ShowWindow(SW_HIDE);
        pEdtPwd->ShowWindow(SW_HIDE);
        CString strPwd;
        pEdtPwd->GetWindowText(strPwd);

        if (strPwd == _T("168888"))
        {
            //m_bLockThis = false;
            //::SetWindowPos(m_hWnd,HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);
        }

        pEdtPwd->SetWindowText(_T(""));
        pBtnUnLock->SetWindowText(_T("解锁"));
    }
    return;
}


void CMainDlg::OnBnClickedButton2()
{
    CButton* btnClock = (CButton*)GetDlgItem(IDC_BUTTON2);
    if (!m_bShowDigitWnd)
    {
        m_digitWnd.Show();
        m_bShowDigitWnd = true;
        btnClock->SetWindowText(_T("隐藏时钟"));
    }
    else
    {
        m_digitWnd.Hide();
        m_bShowDigitWnd = false;
        btnClock->SetWindowText(_T("显示时钟"));
    }
    
}


BOOL CAboutDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    CStatic* pstcTime = (CStatic*)GetDlgItem(IDC_STATIC_BUILDTIME);

     TCHAR szBuildTime[100];
    _stprintf_s(szBuildTime,_T("Version:1.0.4   BuildTime: %s %s"),_T(__DATE__),_T(__TIME__));
     pstcTime->SetWindowText(szBuildTime) ;

    return TRUE;  
}


void CMainDlg::OnBnClickedButton3()
{
    CButton* pBtnCtrl = (CButton*)GetDlgItem(IDC_BUTTON3);
    static bool bShow = true;
    if (!bShow)
    {
        m_edtText.ShowWindow(SW_SHOW);
        bShow = true;
        pBtnCtrl->SetWindowText(_T("隐藏文本"));
    }
    else
    {
        m_edtText.ShowWindow(SW_HIDE);
        bShow = false;
        pBtnCtrl->SetWindowText(_T("显示文本"));
    }
}

    LRESULT CMainDlg::OnTrayNotify(WPARAM /*wp*/, LPARAM lp)
    {
        UINT uiMsg = (UINT) lp;
    
        switch (uiMsg)
        {
        case WM_RBUTTONUP:
            //OnTrayContextMenu ();
            return 1;
    
        case WM_LBUTTONDBLCLK:
            ShowWindow (SW_SHOWNORMAL);
            return 1;
        }
        return 0;
    }